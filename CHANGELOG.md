# Office365DnsChecker Change Log

## Recent changes
- Ignore PSScriptAnalyzer warnings about plural nouns.  Our nouns are intentionally plural when appropriate.

## Version 1.0.3 (July 26, 2021)
- Fixed a regression bug where DKIM records were marked as incorrect on macOS and Linux systems.

## Version 1.0.2 (July 26, 2021)
- Fixed a bug where DKIM records were not validated correctly.
- Code cleanup.

## Version 1.0.1 (March 30, 2020)
- Fixed a bug in `Test-ExchangeOnlineDkimRecords` where some versions of PowerShell could not find the type UInt.

## Version 1.0.0 (November 11, 2019)
- Initial release.
