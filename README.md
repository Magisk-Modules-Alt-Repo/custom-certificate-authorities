## About
Custom Certificate Authorities is a Magisk module that moves user-installed certificate authorities into the system trust store, making them trusted by all apps — including those that use BoringSSL (such as Flutter/Dart apps).

What sets it apart from similar modules:
- **No manual certificate preparation required** — just install the certificate through Android Settings and the module handles the rest.
- **Automatic DER-to-PEM conversion** — certificates in DER (binary) format are automatically converted to PEM, ensuring compatibility with BoringSSL/Flutter apps that require PEM format.
- **Full Android 14+ support** — certificates are injected into both `/apex/com.android.conscrypt/cacerts` and `/system/etc/security/cacerts` via bind mounts, covering both the modern APEX trust store and the legacy path used by BoringSSL.
- **Multi-user support** — certificates from all Android user profiles are included.

### Requirements
- Android 11 or newer
- [Magisk](https://github.com/topjohnwu/Magisk) v24.1 or newer

### Installing the module
1. Download the module from the [GitHub releases page](/../../releases).
2. Install the module with Magisk.

### Adding certificates
1. Install your CA certificate through **Settings → Security → Encryption & credentials → Install a certificate → CA certificate**.
2. Reboot.

The module will automatically copy the certificate from the user store to the system trust store on each boot. DER-encoded certificates are automatically converted to PEM format.

### Removing certificates
1. Remove the certificate through **Settings → Security → Encryption & credentials → Trusted credentials → User** tab.
2. Reboot.

### Verifying installation
After rebooting, you can verify the certificate was installed by checking the log file:

```
adb shell su -c 'cat /data/local/tmp/customcert.log'
```

The certificate should also appear under **Settings → Security → Encryption & credentials → Trusted credentials → System** tab.

### Troubleshooting

#### Certificate not trusted by Flutter/Dart apps
This module automatically converts DER certificates to PEM and mounts them to `/system/etc/security/cacerts` (the path Flutter's BoringSSL reads from). If you're still having issues, ensure you've rebooted after installing the certificate.

#### Certificate not trusted by any app
Check the log file at `/data/local/tmp/customcert.log` for errors. Common issues:
- The certificate wasn't installed through Android Settings before rebooting.
- The module is disabled in Magisk.

### Advanced: Manual certificate installation
If you prefer to prepare certificates manually (e.g., for certificates not installable through Android Settings):

1. Convert the certificate to the Android hash-named format:
```
$ openssl x509 -subject_hash_old -noout -in example.crt
829893ef
$ cp example.crt 829893ef.0
```

2. Using a root file explorer, copy the `.0` file to `/data/misc/user/0/cacerts-added/`.
3. Reboot.
