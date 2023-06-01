---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-TeamsRecords.md
schema: 2.0.0
---

# Test-TeamsRecords

## SYNOPSIS
Verifies that a domain's Teams/Skype for Business DNS records are all correct.

## SYNTAX

```
Test-TeamsRecords [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the four Microsoft Teams/Skype for Business Online DNS records:  the CNAME sip, the CNAME lyncdiscover, the SRV record for _sip._tls, and the SRV records for _sipfederationtls._tcp.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-TeamsRecords contoso.com
```

Verifies that the DNS CNAME records sip.contoso.com and lyncdiscover.contoso.com are correct; and that the first service returned by SRV record lookups for _sip._tls.contoso.com and _sipfederationtls._tcp.contoso.com point to Teams/Skype for Business Online.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-TeamsRecords
```

For contoso.com, fabrikam.com, and tailspintoys.com; this will verify that the DNS CNAME records sip and lyncdiscover are correct, and that the first service returned by SRV record lookups for _sip._tls and _sipfederationtls._tcp point to Teams/Skype for Business Online.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
One or more domain names to check. 
This cmdlet accepts pipeline input as well.

## OUTPUTS

## NOTES
Some phone systems, as well as Skype for Business Server and Lync Server, may require these DNS records to be intentionally incorrect. 
Thus, incorrect DNS records may not print an error message, only a warning.

This documentation uses Microsoft Teams, though these DNS records apply equally to Skype for Business Online.

## RELATED LINKS

[about_Office365DnsChecker]()

[Test-TeamsSipCnameRecord]()

[Test-TeamsSipSrvRecord]()

[Test-TeamsSipFederationSrvRecord]()

[Test-TeamsAutodiscoverRecord]()

