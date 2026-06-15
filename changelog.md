## [1.2.0] - 2025-06-15
### Changed
- Read certificates from Android's standard user cert store (`cacerts-added`) instead of a custom directory
- Certificates can now be installed through Android Settings instead of manual preparation

### Added
- Automatic DER-to-PEM conversion for Flutter/BoringSSL compatibility
- Bind mount to `/system/etc/security/cacerts` (legacy path) in addition to APEX, fixing certificate trust for Flutter/Dart apps
- Multi-user support (certificates from all user profiles are included)

### Fixed
- Flutter/Dart apps not trusting custom certificates due to BoringSSL requiring PEM format from `/system/etc/security/cacerts`

## [1.1.0] - 2024-01-22
### Fixed
- Added support for Android 14 (Thanks to @sfionov 's [PR](https://github.com/AdguardTeam/adguardcert/pull/53))
- Added dist.sh script to help build the module