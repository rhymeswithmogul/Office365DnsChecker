---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-ExchangeOnlineAutodiscoverRecord.md
schema: 2.0.0
---

# Test-ExchangeOnlineAutodiscoverRecord

## SYNOPSIS
Verifies that a domain's Outlook Autodiscover DNS records are correct.

## SYNTAX

```
Test-ExchangeOnlineAutodiscoverRecord [-DomainName] <String> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Outlook Autodiscover DNS record, named autodiscover. 
It should be a CNAME pointing to autodiscover.outlook.com.

This cmdlet will also verify that no Autodiscover DNS SRV records exist, as those are not compatible with Exchange Online.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineAutodiscoverRecord contoso.com
```

Verifies that the DNS CNAME record autodiscover.contoso.com is correct, and that records for _autodiscover._tcp.contoso.com do not exist.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-ExchangeOnlineAutodiscoverRecord
```

Verifies that the DNS CNAME records autodiscover.contoso.com, autodiscover.fabrikam.com, and autodiscover.tailspintoys.com are correct; and that records for _autodiscover._tcp.contoso.com, _autodiscover._tcp.fabrikam.com, and _autodiscover._tcp.tailspintoys.com do not exist.

## PARAMETERS

### -DomainName
One or more domain names to check.

```yaml
Type: String
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
If you have a hybrid Exchange setup, your Autodiscover DNS records may not be pointing directly to Exchange Online.  Use your best judgement when reviewing the opinions of this cmdlet.

## RELATED LINKS

[Test-ExchangeOnlineRecords]()

[Test-Office365DnsRecords]()

[about_Office365DnsChecker]()

