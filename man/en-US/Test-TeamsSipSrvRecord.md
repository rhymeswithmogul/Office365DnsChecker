---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-TeamsSipSrvRecord.md
schema: 2.0.0
---

# Test-TeamsSipSrvRecord

## SYNOPSIS
Verifies that a domain's Teams/Skype for Business SIP-over-TLS service records are correct.

## SYNTAX

```
Test-TeamsSipSrvRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Microsoft Teams and Skype for Business SIP service record.  The highest-ranking SRV record for the service _sip and the protocol _tls must have a target of sipdir.online.lync.com, port 443.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-AzureADClientConfigurationRecord contoso.com
```

Verifies that the DNS CNAME record msoid.contoso.com is correct.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-AzureADClientConfigurationRecord
```

Verifies that the DNS CNAME records msoid.contoso.com, msoid.fabrikam.com, and msoid.tailspintoys.com are correct.

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
If you are using another SIP service in addition to Microsoft Teams or Skype for Business Online, then you might have extra _sip._tls SRV records.  While not recommended, it is not incorrect, as long as the lowest-priority service is always the one for Microsoft Teams/Skype for Business Online.

## RELATED LINKS

[Test-TeamsRecords]()

[about_Office365DnsChecker]()

[Test-Office365DnsRecords]()

