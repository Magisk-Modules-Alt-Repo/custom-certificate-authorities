#!/system/bin/sh

exec > /data/local/tmp/customcert.log
exec 2>&1

set -x

set_context() {
    [ "$(getenforce)" = "Enforcing" ] || return 0

    default_selinux_context=u:object_r:system_file:s0
    selinux_context=$(ls -Zd $1 | awk '{print $1}')

    if [ -n "$selinux_context" ] && [ "$selinux_context" != "?" ]; then
        chcon -R $selinux_context $2
    else
        chcon -R $default_selinux_context $2
    fi
}

# Convert DER-encoded certificates to PEM format.
# Required for BoringSSL (used by Flutter/Dart) which only accepts PEM
# from /system/etc/security/cacerts, unlike Android's Java CertificateFactory
# which handles both DER and PEM.
der_to_pem() {
    for cert in "$1"/*; do
        [ -f "$cert" ] || continue
        if ! grep -q "BEGIN CERTIFICATE" "$cert" 2>/dev/null; then
            echo "-----BEGIN CERTIFICATE-----" > "${cert}.tmp"
            base64 "$cert" >> "${cert}.tmp"
            echo "-----END CERTIFICATE-----" >> "${cert}.tmp"
            mv "${cert}.tmp" "$cert"
        fi
    done
}

MODDIR=${0%/*}

mkdir -p $MODDIR/system/etc/security/cacerts
rm $MODDIR/system/etc/security/cacerts/*
cp -f /data/misc/user/*/cacerts-added/* $MODDIR/system/etc/security/cacerts/
der_to_pem $MODDIR/system/etc/security/cacerts
chown -R root:root $MODDIR/system/etc/security/cacerts
chmod -R ugo-rwx,ugo+rX,u+w $MODDIR/system/etc/security/cacerts
chcon -R u:object_r:system_security_cacerts_file:s0 $MODDIR/system/etc/security/cacerts
touch -t 200901010000.00 $MODDIR/system/etc/security/cacerts/*
set_context /system/etc/security/cacerts ${MODDIR}/system/etc/security/cacerts

# Android 14+ support
# The system CA store moved to /apex/com.android.conscrypt/cacerts.
# Magisk can't overlay /apex, and the Magisk overlay for /system/etc/security/cacerts
# doesn't reliably include module-added certs.
# Flutter/BoringSSL hardcodes /system/etc/security/cacerts.
# Fix: bind-mount a merged tmpfs to BOTH locations.

# Determine the source of system CA certs
if [ -d /apex/com.android.conscrypt/cacerts ]; then
    SYSTEM_CACERTS=/apex/com.android.conscrypt/cacerts
else
    SYSTEM_CACERTS=/system/etc/security/cacerts
fi

# Create a tmpfs with merged system + user certs
rm -f /data/local/tmp/custom-ca-copy
mkdir -p /data/local/tmp/custom-ca-copy
mount -t tmpfs tmpfs /data/local/tmp/custom-ca-copy

# Copy system certs
cp -f ${SYSTEM_CACERTS}/* /data/local/tmp/custom-ca-copy/

# Copy user certs and convert DER to PEM
cp -f /data/misc/user/*/cacerts-added/* /data/local/tmp/custom-ca-copy/
der_to_pem /data/local/tmp/custom-ca-copy

# Set ownership, permissions, and SELinux context
chown -R root:root /data/local/tmp/custom-ca-copy
chmod -R ugo-rwx,ugo+rX,u+w /data/local/tmp/custom-ca-copy
chcon -R u:object_r:system_security_cacerts_file:s0 /data/local/tmp/custom-ca-copy
touch -t 200901010000.00 /data/local/tmp/custom-ca-copy/*
set_context ${SYSTEM_CACERTS} /data/local/tmp/custom-ca-copy

# Mount directory if it is valid
CERTS_NUM="$(ls -1 /data/local/tmp/custom-ca-copy | wc -l)"
if [ "$CERTS_NUM" -gt 10 ]; then
    # Bind mount to both APEX and legacy /system paths
    mount --bind /data/local/tmp/custom-ca-copy ${SYSTEM_CACERTS}
    mount --bind /data/local/tmp/custom-ca-copy /system/etc/security/cacerts

    # Propagate into all mount namespaces (init + zygote)
    for pid in 1 $(pgrep zygote) $(pgrep zygote64); do
        nsenter --mount=/proc/${pid}/ns/mnt -- \
            /bin/mount --bind /data/local/tmp/custom-ca-copy ${SYSTEM_CACERTS} 2>/dev/null
        nsenter --mount=/proc/${pid}/ns/mnt -- \
            /bin/mount --bind /data/local/tmp/custom-ca-copy /system/etc/security/cacerts 2>/dev/null
    done
else
    echo "Cancelling replacing CA storage due to safety"
fi

# Clean up the tmpfs mount point (bind mounts keep the data alive)
umount /data/local/tmp/custom-ca-copy 2>/dev/null
rmdir /data/local/tmp/custom-ca-copy 2>/dev/null