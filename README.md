## About
Custom Certificate Authorities is a Magisk module which adds custom certificate authorities from a pre-defined path on the Android file system to the system trust store.

What sets it apart from similar modules like [MagiskTrustUserCerts](https://github.com/NVISOsecurity/MagiskTrustUserCerts) or [MoveCert](https://github.com/Magisk-Modules-Repo/movecert) is that it doesn't require you to install or continuously store the certificates in the user store.

### Requirements
- Android 11 or newer
- [Magisk](https://github.com/topjohnwu/Magisk) v24.1 or newer
- A root file explorer (e.g., [Amaze](https://github.com/TeamAmaze/AmazeFileManager) or [Solid Explorer](https://neatbytes.com/solidexplorer/))
- A terminal emulator with [Coreutils](https://www.gnu.org/software/coreutils/) and [OpenSSL](https://www.openssl.org) (e.g., [Cygwin](https://www.cygwin.com) or [MSYS2](https://www.msys2.org) on Windows)

### Installing the module
1. Download the module from the [GitHub releases page](/../../releases).
2. Install the module with Magisk.

### Preparing a folder for the certificates
1. Using a root file explorer, create the folder `/data/misc/user/0/cacerts-custom` on your phone.

⚠ Please note that creating the folder `cacerts-custom` in `/storage/0/emulated` or `/sdcard` will **not** work. 

### Preparing the certificates
1. Launch Cygwin or MSYS2 on Windows or open a terminal emulator on Linux/Android/macOS/BSD.
2. Verify that the certificate file is [PEM-encoded](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail).

```
$ cat example.crt
-----BEGIN CERTIFICATE-----
MIIBzzCCAXWgAwIBAgIQXLyRodQLpSqV0DpAU0NoJDAKBggqhkjOPQQDAjBGMR0w
GwYDVQQKExRQcm9qZWN0IERhdGEgSG9hcmRlcjElMCMGA1UEAxMcUHJvamVjdCBE
YXRhIEhvYXJkZXIgUm9vdCBDQTAeFw0yMjAxMTUyMTQ2MDVaFw0zMjAxMTMyMTQ2
MDVaMEYxHTAbBgNVBAoTFFByb2plY3QgRGF0YSBIb2FyZGVyMSUwIwYDVQQDExxQ
cm9qZWN0IERhdGEgSG9hcmRlciBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0D
AQcDQgAENNsPYGcVUZb+CQXnViuakArj9GaJIxJLlcreUhVafwbEjF0gLwTv2ejv
ad3i4I7YFD1mxkluApIY4m1Dxv8gfKNFMEMwDgYDVR0PAQH/BAQDAgEGMBIGA1Ud
EwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFDLo84jisTNeQqnzvHiQEIq+WsHhMAoG
CCqGSM49BAMCA0gAMEUCIQC6RbYaWCeBjxYBx/F+ZtAsJwlqzwAzNkqu/A5oJhfF
sgIgK823XQmP2I0pBmhHXL/63sAqNgQBFv8M6+c8BaNwVSU=
-----END CERTIFICATE-----
```

3. If the certificate file is [DER-encoded](https://en.wikipedia.org/wiki/X.690#DER_encoding), convert it to PEM before proceeding.

```
$ openssl x509 -inform DER -outform PEM -in example.crt -out example.crt
```

4. Convert the certificate file to the correct format.

```
$ openssl x509 -noout -text -fingerprint -in example.crt >> example.crt
```

5. Verify that the certificate file has the correct format.

```
$ cat example.crt
-----BEGIN CERTIFICATE-----
MIIBzzCCAXWgAwIBAgIQXLyRodQLpSqV0DpAU0NoJDAKBggqhkjOPQQDAjBGMR0w
GwYDVQQKExRQcm9qZWN0IERhdGEgSG9hcmRlcjElMCMGA1UEAxMcUHJvamVjdCBE
YXRhIEhvYXJkZXIgUm9vdCBDQTAeFw0yMjAxMTUyMTQ2MDVaFw0zMjAxMTMyMTQ2
MDVaMEYxHTAbBgNVBAoTFFByb2plY3QgRGF0YSBIb2FyZGVyMSUwIwYDVQQDExxQ
cm9qZWN0IERhdGEgSG9hcmRlciBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0D
AQcDQgAENNsPYGcVUZb+CQXnViuakArj9GaJIxJLlcreUhVafwbEjF0gLwTv2ejv
ad3i4I7YFD1mxkluApIY4m1Dxv8gfKNFMEMwDgYDVR0PAQH/BAQDAgEGMBIGA1Ud
EwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFDLo84jisTNeQqnzvHiQEIq+WsHhMAoG
CCqGSM49BAMCA0gAMEUCIQC6RbYaWCeBjxYBx/F+ZtAsJwlqzwAzNkqu/A5oJhfF
sgIgK823XQmP2I0pBmhHXL/63sAqNgQBFv8M6+c8BaNwVSU=
-----END CERTIFICATE-----
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            5c:bc:91:a1:d4:0b:a5:2a:95:d0:3a:40:53:43:68:24
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: O = Project Data Hoarder, CN = Project Data Hoarder Root CA
        Validity
            Not Before: Jan 15 21:46:05 2022 GMT
            Not After : Jan 13 21:46:05 2032 GMT
        Subject: O = Project Data Hoarder, CN = Project Data Hoarder Root CA
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:34:db:0f:60:67:15:51:96:fe:09:05:e7:56:2b:
                    9a:90:0a:e3:f4:66:89:23:12:4b:95:ca:de:52:15:
                    5a:7f:06:c4:8c:5d:20:2f:04:ef:d9:e8:ef:69:dd:
                    e2:e0:8e:d8:14:3d:66:c6:49:6e:02:92:18:e2:6d:
                    43:c6:ff:20:7c
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:1
            X509v3 Subject Key Identifier:
                32:E8:F3:88:E2:B1:33:5E:42:A9:F3:BC:78:90:10:8A:BE:5A:C1:E1
    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:21:00:ba:45:b6:1a:58:27:81:8f:16:01:c7:f1:7e:
         66:d0:2c:27:09:6a:cf:00:33:36:4a:ae:fc:0e:68:26:17:c5:
         b2:02:20:2b:cd:b7:5d:09:8f:d8:8d:29:06:68:47:5c:bf:fa:
         de:c0:2a:36:04:01:16:ff:0c:eb:e7:3c:05:a3:70:55:25
SHA1 Fingerprint=7E:5E:8A:73:0D:C9:86:A8:20:63:D1:38:53:38:B3:19:5C:C6:79:08
```

6. Rename the certificate file to the correct format.

```
$ mv -v example.crt "$(openssl x509 -subject_hash_old -noout -in example.crt)".0
'example.crt' -> '829893ef.0'
```

### Adding certificates
1. Using a root file explorer, copy the `.0` certificate file(s) to `/data/misc/user/0/cacerts-custom`.
2. Reboot.

### Removing certificates
1. Using a root file explorer, delete the `.0` certificate file(s) from `/data/misc/user/0/cacerts-custom`.
2. Reboot.
