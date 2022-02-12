#!/system/bin/sh

MODDIR=${0%/*}

mkdir -p $MODDIR/system/etc/security/cacerts
rm $MODDIR/system/etc/security/cacerts/*
cp -f /data/misc/user/0/cacerts-custom/* $MODDIR/system/etc/security/cacerts/
set_perm_recursive $MODDIR/system/etc/security/cacerts/ root root 644
