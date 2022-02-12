## About
Custom Certificate Authorities is a Magisk module which adds custom certificate authorities from a pre-defined path on the Android file system to the system trust store.

What sets it apart from similar modules like [MagiskTrustUserCerts](https://github.com/NVISOsecurity/MagiskTrustUserCerts) or [MoveCert](https://github.com/Magisk-Modules-Repo/movecert) is that it doesn't require you to install or continuously store the certificates in the user store.

### Requirements
- Android 11 or newer
- [Cygwin](https://www.cygwin.com) (or Linux)
- [Magisk](https://github.com/topjohnwu/Magisk)

### Installing the module
1. Download the module from the [GitHub releases page](https://github.com/whalehub/custom-certificate-authorities/releases).
2. Install the module with Magisk.
3. Create the folder `/data/misc/user/0/cacerts-custom` on your phone using either a terminal emulator like [Termux](https://github.com/termux/termux-app) or a root file explorer app like [Root Explorer](https://play.google.com/store/apps/details?id=com.speedsoftware.rootexplorer).

### Preparing certificates
1. Launch Cygwin on Windows or open a terminal on Linux.
2. Verify that the certificate is [PEM-encoded](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail).

```
$ cat example.crt
-----BEGIN CERTIFICATE-----
MIIB+DCCAZ+gAwIBAgIRAKgMapsVZUdtMj0YFrimNGowCgYIKoZIzj0EAwIwRjEd
MBsGA1UEChMUUHJvamVjdCBEYXRhIEhvYXJkZXIxJTAjBgNVBAMTHFByb2plY3Qg
RGF0YSBIb2FyZGVyIFJvb3QgQ0EwHhcNMjIwMTE1MjE0NjA2WhcNMzIwMTEzMjE0
NjA2WjBOMR0wGwYDVQQKExRQcm9qZWN0IERhdGEgSG9hcmRlcjEtMCsGA1UEAxMk
UHJvamVjdCBEYXRhIEhvYXJkZXIgSW50ZXJtZWRpYXRlIENBMFkwEwYHKoZIzj0C
AQYIKoZIzj0DAQcDQgAEW+U2FDAZBuyvyPD+yadP7QDnWDV4cp2eQqAnT1x2oNoy
LXcbc7QgjHRgFAcQpaRZ49Y3/tMM/i1mJvgEhN4xaqNmMGQwDgYDVR0PAQH/BAQD
AgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFOtAts3k+cYZLfHoLcJL
eN+BzlsIMB8GA1UdIwQYMBaAFDLo84jisTNeQqnzvHiQEIq+WsHhMAoGCCqGSM49
BAMCA0cAMEQCIG9ZP4LVhZfOc8bZcfXKnKhGp97r/P20aYSeRtAwuLjKAiBKMRJQ
9mJMs7sPyW/6t1psAFmuvcS2Uqo7TXBg393wjQ==
-----END CERTIFICATE-----
```

3. If the certificate is [DER-encoded](https://en.wikipedia.org/wiki/X.690#DER_encoding), convert it to PEM before proceeding.

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
MIIB+DCCAZ+gAwIBAgIRAKgMapsVZUdtMj0YFrimNGowCgYIKoZIzj0EAwIwRjEd
MBsGA1UEChMUUHJvamVjdCBEYXRhIEhvYXJkZXIxJTAjBgNVBAMTHFByb2plY3Qg
RGF0YSBIb2FyZGVyIFJvb3QgQ0EwHhcNMjIwMTE1MjE0NjA2WhcNMzIwMTEzMjE0
NjA2WjBOMR0wGwYDVQQKExRQcm9qZWN0IERhdGEgSG9hcmRlcjEtMCsGA1UEAxMk
UHJvamVjdCBEYXRhIEhvYXJkZXIgSW50ZXJtZWRpYXRlIENBMFkwEwYHKoZIzj0C
AQYIKoZIzj0DAQcDQgAEW+U2FDAZBuyvyPD+yadP7QDnWDV4cp2eQqAnT1x2oNoy
LXcbc7QgjHRgFAcQpaRZ49Y3/tMM/i1mJvgEhN4xaqNmMGQwDgYDVR0PAQH/BAQD
AgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFOtAts3k+cYZLfHoLcJL
eN+BzlsIMB8GA1UdIwQYMBaAFDLo84jisTNeQqnzvHiQEIq+WsHhMAoGCCqGSM49
BAMCA0cAMEQCIG9ZP4LVhZfOc8bZcfXKnKhGp97r/P20aYSeRtAwuLjKAiBKMRJQ
9mJMs7sPyW/6t1psAFmuvcS2Uqo7TXBg393wjQ==
-----END CERTIFICATE-----
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            a8:0c:6a:9b:15:65:47:6d:32:3d:18:16:b8:a6:34:6a
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: O = Project Data Hoarder, CN = Project Data Hoarder Root CA
        Validity
            Not Before: Jan 15 21:46:06 2022 GMT
            Not After : Jan 13 21:46:06 2032 GMT
        Subject: O = Project Data Hoarder, CN = Project Data Hoarder Intermediate CA
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:5b:e5:36:14:30:19:06:ec:af:c8:f0:fe:c9:a7:
                    4f:ed:00:e7:58:35:78:72:9d:9e:42:a0:27:4f:5c:
                    76:a0:da:32:2d:77:1b:73:b4:20:8c:74:60:14:07:
                    10:a5:a4:59:e3:d6:37:fe:d3:0c:fe:2d:66:26:f8:
                    04:84:de:31:6a
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier:
                EB:40:B6:CD:E4:F9:C6:19:2D:F1:E8:2D:C2:4B:78:DF:81:CE:5B:08
            X509v3 Authority Key Identifier:
                keyid:32:E8:F3:88:E2:B1:33:5E:42:A9:F3:BC:78:90:10:8A:BE:5A:C1:E1

    Signature Algorithm: ecdsa-with-SHA256
         30:44:02:20:6f:59:3f:82:d5:85:97:ce:73:c6:d9:71:f5:ca:
         9c:a8:46:a7:de:eb:fc:fd:b4:69:84:9e:46:d0:30:b8:b8:ca:
         02:20:4a:31:12:50:f6:62:4c:b3:bb:0f:c9:6f:fa:b7:5a:6c:
         00:59:ae:bd:c4:b6:52:aa:3b:4d:70:60:df:dd:f0:8d
SHA1 Fingerprint=A1:22:5A:9C:0D:4E:83:AC:5E:E2:30:F3:B6:9E:77:8B:F6:B4:89:73
```

6. Rename the certificate file to the correct format.

```
$ mv -v example.crt "$(openssl x509 -subject_hash_old -noout -in example.crt)".0
'example.crt' -> '99593a01.0'
```

### Adding certificates
1. Copy the certificate file(s) to `/data/misc/user/0/cacerts-custom`.
2. Reboot.

### Removing certificates
1. Delete the certificate file(s) from `/data/misc/user/0/cacerts-custom`.
2. Reboot.
