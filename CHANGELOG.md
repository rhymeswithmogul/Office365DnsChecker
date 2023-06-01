# Office365DnsChecker Change Log

## Recent changes
- NEW: Cmdlets now return true or false, depending on the results.  Thanks to @o-l-a-v for suggesting this in issue #1.

## Version 1.1.0 (June 1, 2023)
- NEW: Add support for checking DNS records for Office 365 hosted by 21Vianet.
- ENHANCEMENT: The Azure AD client configuration record check now passes if the `msoid` record is missing.  As of <time datetime="2023-02-16">early 2023</time>, this DNS record is only required to be set when Office 365 is managed by 21Vianet.
- FIXED: On a small number of configurations, DNS resolution would enter an infinite loop.  This would happen if you were running macOS or Linux, and had an alternative implementation of `Resolve-DnsName`.  Now, the only cmdlet we'll use is `DnsClient` (if present) before falling back to the built-in DNS resolver.
- Code cleanup.
- Renamed the main Git branch from `master` to `main`.

## Version 1.0.4 (June 1, 2023)
- NEW: Added online help.
- NEW: This module will be signed when deployed to PowerShell Gallery so that it can run on systems whose execution policies require code signing.
- ENHANCEMENT: Converted all help files from SAPIEN to platyPS for ease of maintenance.
- ENHANCEMENT: Ignore PSScriptAnalyzer warnings about plural nouns.  Our nouns are intentionally plural when appropriate.
- Code cleanup.

## Version 1.0.3 (July 26, 2021)
- FIXED: Fixed a regression bug where DKIM records were marked as incorrect on macOS and Linux systems.

## Version 1.0.2 (July 26, 2021)
- FIXED: Fixed a bug where DKIM records were not validated correctly.
- Code cleanup.

## Version 1.0.1 (March 30, 2020)
- FIXED: Fixed a bug in `Test-ExchangeOnlineDkimRecords` where some versions of PowerShell could not find the type UInt.

## Version 1.0.0 (November 11, 2019)
- Initial release.
