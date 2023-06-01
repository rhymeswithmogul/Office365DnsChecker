# Office365DnsChecker Change Log

## Recent changes
- NEW: Added online help.
- ENHANCEMENT: Ignore PSScriptAnalyzer warnings about plural nouns.  Our nouns are intentionally plural when appropriate.
- ENHANCEMENT: Converted all help files from SAPIEN to platyPS for ease of maintenance.

## Version 1.0.3 (July 26, 2021)
- FIXED: Fixed a regression bug where DKIM records were marked as incorrect on macOS and Linux systems.

## Version 1.0.2 (July 26, 2021)
- FIXED: Fixed a bug where DKIM records were not validated correctly.
- Code cleanup.

## Version 1.0.1 (March 30, 2020)
- FIXED: Fixed a bug in `Test-ExchangeOnlineDkimRecords` where some versions of PowerShell could not find the type UInt.

## Version 1.0.0 (November 11, 2019)
- Initial release.
