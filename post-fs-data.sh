#!/system/bin/sh

MODDIR=${0%/*}

mkdir -p $MODDIR/system/etc/security/cacerts
rm $MODDIR/system/etc/security/cacerts/*
cp -f /data/misc/user/0/cacerts-custom/* $MODDIR/system/etc/security/cacerts/
chown -R root:root $MODDIR/system/etc/security/cacerts
chmod -R ugo-rwx,ugo+rX,u+w $MODDIR/system/etc/security/cacerts
chcon -R u:object_r:system_security_cacerts_file:s0 $MODDIR/system/etc/security/cacerts
touch -t 200901010000.00 $MODDIR/system/etc/security/cacerts/*
