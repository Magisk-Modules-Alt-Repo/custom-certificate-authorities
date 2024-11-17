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

MODDIR=${0%/*}

mkdir -p $MODDIR/system/etc/security/cacerts
rm $MODDIR/system/etc/security/cacerts/*
cp -f /data/misc/user/0/cacerts-custom/* $MODDIR/system/etc/security/cacerts/
chown -R root:root $MODDIR/system/etc/security/cacerts
chmod -R ugo-rwx,ugo+rX,u+w $MODDIR/system/etc/security/cacerts
chcon -R u:object_r:system_security_cacerts_file:s0 $MODDIR/system/etc/security/cacerts
touch -t 200901010000.00 $MODDIR/system/etc/security/cacerts/*
set_context /system/etc/security/cacerts ${MODDIR}/system/etc/security/cacerts

# Android 14 support
# Since Magisk ignore /apex for module file injections, use non-Magisk way
if [ -d /apex/com.android.conscrypt/cacerts ]; then
    # Clone directory into tmpfs
    rm -f /data/local/tmp/custom-ca-copy
    mkdir -p /data/local/tmp/custom-ca-copy
    mount -t tmpfs tmpfs /data/local/tmp/custom-ca-copy
    cp -f /apex/com.android.conscrypt/cacerts/* /data/local/tmp/custom-ca-copy/

    # Do the same as in Magisk module
    cp -f /data/misc/user/0/cacerts-custom/* /data/local/tmp/custom-ca-copy/
    chown -R root:root /data/local/tmp/custom-ca-copy
    chmod -R ugo-rwx,ugo+rX,u+w /data/local/tmp/custom-ca-copy
    chcon -R u:object_r:system_security_cacerts_file:s0 /data/local/tmp/custom-ca-copy
    touch -t 200901010000.00 /data/local/tmp/custom-ca-copy/*
    set_context /apex/com.android.conscrypt/cacerts /data/local/tmp/custom-ca-copy

    # Mount directory inside APEX if it is valid, and remove temporary one.
    CERTS_NUM="$(ls -1 /data/local/tmp/custom-ca-copy | wc -l)"
    if [ "$CERTS_NUM" -gt 10 ]; then
        mount --bind /data/local/tmp/custom-ca-copy /apex/com.android.conscrypt/cacerts
        for pid in 1 $(pgrep zygote) $(pgrep zygote64); do
            nsenter --mount=/proc/${pid}/ns/mnt -- \
                /bin/mount --bind /data/local/tmp/custom-ca-copy /apex/com.android.conscrypt/cacerts
        done
    else
        echo "Cancelling replacing CA storage due to safety"
    fi
    umount /data/local/tmp/custom-ca-copy
    rmdir /data/local/tmp/custom-ca-copy
fi