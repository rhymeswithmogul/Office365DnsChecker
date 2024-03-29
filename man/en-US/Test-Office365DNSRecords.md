---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-Office365DNSRecords.md
schema: 2.0.0
---

# Test-Office365DNSRecords

## SYNOPSIS
Verifies that all of a domain's Office 365 DNS records are correct.

## SYNTAX

```
Test-Office365DNSRecords [-DomainName] <String[]> [-Use21Vianet] [-DANERequired] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will check for the presence and correctness of all of one or more domains' DNS records that support all of Office 365's services, including Entra ID, Exchange Online, Microsoft Teams, and Skype for Business.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-Office365DnsRecords contoso.com
```

Verifies that the all of the DNS records for contoso.com are correct.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-Office365DnsRecords
```

Verifies that all of the DNS records for contoso.com, fabrikam.com, and tailspintoys.com are correct.

### EXAMPLE 3
```
PS C:\> $error[0].ErrorDetails.RecommendedAction
Create a SRV record for _sipfederationtls._tcp.woodgrovebank.com (port 5061) pointing to sipfed.online.lync.com.
```

Recommended actions are included in the error objects, though PowerShell doesn't display them by default.  They can be retrieved through the $error automatic variables, as children of each $error's ErrorDetails object.

### EXAMPLE 4
```
PS C:\> Test-Office365DnsRecords woodgrovebank.com -InformationAction Continue

Create a CNAME record for msoid.woodgrovebank.com, pointing to clientconfig.microsoftonline-p.net.
Create a CNAME record for enterpriseenrollment.woodgrovebank.com, pointing to enterpriseenrollment.manage.microsoft.com.
Create a CNAME record for enterpriseregistration.woodgrovebank.com, pointing to enterpriseregistration.windows.net.
Create a CNAME record for autodiscover.woodgrovebank.com, pointing to autodiscover.outlook.com.
Create a CNAME record for selector1._domainkey.woodgrovebank.com.  Look in the Exchange Admin Center to find the target.
Create a CNAME record for selector2._domainkey.woodgrovebank.com.  Look in the Exchange Admin Center to find the target.
Create a CNAME record for lyncdiscoverwoodgrovebank.com, pointing to webdir.online.lync.com.
Create a CNAME record for sip.woodgrovebank.com, pointing to sipdir.online.lync.com.
Create a SRV record for _sip._tls.woodgrovebank.com (port 443) pointing to sipdir.online.lync.com.
Create a SRV record for _sipfederationtls._tcp.woodgrovebank.com (port 5061) pointing to sipfed.online.lync.com.
```

Recommended actions are also sent to the information pipeline.  You can show it on the screen with -InformationAction Continue, or redirect it (pipeline number six) to a file to view later.

## PARAMETERS

### -DomainName
One or more domain names to check.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Use21Vianet
If your Office 365 tenant is hosted by 21Vianet, include this switch.  Chinese customers must have the msoid attribute set to a special value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: China

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DANERequired
To make the use of the legacy MX endpoint (i.e., contoso-com.mail.protection.outlook.com) a warning instead of a passing message, include this parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
One or more domain names to check.  This cmdlet accepts pipeline input as well.

## OUTPUTS

### Bool
True if all DNS records are correct, false otherwise.  If you pass multiple domain names to this cmdlet, the result will consider all domains;  that is, if contoso.com is correct but fabrikam.com is not, the result will be false.

## NOTES
Microsoft Entra ID used to be called Microsoft Azure Active Directory, and previous versions of this cmdlet reflected that.

## RELATED LINKS

[about_Office365DnsChecker]()

[Test-EntraIDJoinRecords]()

[Test-ExchangeOnlineRecords]()

[Test-TeamsRecords]()

