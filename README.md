# Office365DnsChecker
Office365DnsChecker will check one or more domains, to make sure that their current DNS records are set up correctly and completely for Office 365.

<img src="https://raw.githubusercontent.com/rhymeswithmogul/Office365DnsChecker/master/Logo/Office365DnsChecker.png" alt="Office365DnsChecker logo" width="432" height="300" style="margin:0 auto">

## System Requirements
This module requires Windows PowerShell 5.1 or greater.  It works great on PoewrShell Core.

Additionally, Linux users will need to install the app `dig` (part of [`bind-utils`](https://github.com/tigeli/bind-utils)).  It is installed by default on macOS (at least in High Sierra).

## Installation
You can clone this repository and put it in your `$PSModulePath`, or grab it from PSGallery:
````powershell
Install-Module -Name Office365DnsChecker
````

## Usage
You can check all applicable Office 365 DNS records at once with the cmdlet `Test-Office365DnsRecords`:
````powershell
PS C:\> Test-Office365DnsRecords "contoso.com"
````

These cmdlets also accept pipeline input.  If you're logged into Exchange Online, use the following command to test all of your organization's domains.
````powershell
PS C:\> Get-AcceptedDomain | Test-Office365DnsRecords
````

### Advanced Usage
You can also check individual services:
- `Test-AzureADRecords`
- `Test-ExchangeOnlineRecords`
- `Test-TeamsRecords` (or `Test-SkypeForBusinessOnlineRecords`)

Or, you can even check individual DNS records:
- `Test-AzureADClientConfigurationRecord` to check the <tt>msoid</tt> CNAME.
- `Test-AzureADEnterpriseEnrollmentRecord` to check the <tt>enterpriseenrollment</tt> CNAME.
- `Test-AzureADEnterpriseRegistrationRecord` to check the <tt>enterpriseregistration</tt> CNAME.
- `Test-ExchangeOnlineAutodiscoverRecord` to check both the existence of the <tt>autodiscover</tt> CNAME, and the non-existence of <tt>_autodiscover._tcp</tt> <abbr title="service">SRV</abbr> records.
- `Test-ExchangeOnlineDkimRecords` to check the <tt>selector1</tt> and <tt>selector2</tt> DKIM records.
- `Test-ExchangeOnlineMxRecord` to check the domain's MX record(s).
- `Test-ExchangeOnlineSenderIdRecord` to check the domain's [Sender ID](https://tools.ietf.org/html/rfc4406) record, if present.
- `Test-ExchangeOnlineSpfRecord` to check the domain's [<abbr title="Sender Policy Framework">SPF</abbr>](https://tools.ietf.org/html/rfc7208) <abbr title="text">TXT</abbr> record.
- `Test-TeamsAutodiscoverRecord` to check the <tt>lyncdiscover</tt> CNAME.
- `Test-TeamsSipCnameRecord` to check the <tt>sip</tt> CNAME.
- `Test-TeamsSipSrvRecord` to check the <tt>_sip._tls</tt> <abbr title="service">SRV</abbr> record(s).
- `Test-TeamsSipFederationSrvRecord` to check the <tt>_sipfederationtls._tcp</tt> <abbr title="service">SRV</abbr> record(s).

### Identifying problems
When you run one of this module's commands, the corresponding DNS records are retrieved and evaluated.  In case of an incorrect record, a warning or an error may be printed to the screen, telling you which records are wrong or missing.

If an error is printed, you can retrieve the error object through the `$error` automatic variable, just like PowerShell supports normally:

````powershell
$error[0].ErrorDetails
````

### Getting help for resolving problems
In addition, basic steps to resolving the error may be available through the information pipeline. You can make this information visible by regular means such as specifying `-InformationAction Continue`, setting `$InformationPreference`, or redirecting the information pipeline (six).  This information is also available in the error object's details.

````powershell
# this works.
Test-Office365DnsRecords "contoso.com" -InformationAction Continue

# this also works.
Test-Office365DnsRecords "contoso.com" 6> howtofixcontoso.txt

# this works, too.
$error[0].ErrorDetails.RecommendedAction
````

While the included one- or two-sentence tips may be useful for giving Office 365 administrators some idea on how to fix any DNS problems, you should still consult the [Microsoft 365 Admin Center](https://admin.microsoft.com)'s Domains page, which will tell you all but exactly how to fix your DNS records in common scenarios.

In some cases, DNS records may intentionally be incorrect -- for example, if you have a third-party spam filter sitting in front of Exchange Online that requires custom MX records; or, if you have an on-premises Skype for Business Server that requires your Teams-/Skype-related DNS CNAME records to be incorrect intentionally.  Please consult your IT department or your local <abbr title="Microsoft Certified Solution Expert">MCSE</abbr> to make sure that following this module's generic advice won't interrupt your company's operations.
