---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-TeamsAutodiscoverRecords.md
schema: 2.0.0
---

# Test-TeamsAutodiscoverRecord

## SYNOPSIS
Verifies that a domain's Teams/Skype for Business Autodiscover record is correct.

## SYNTAX

```
Test-TeamsAutodiscoverRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Microsoft Teams/Skype for Business Online Autodiscover DNS record, named lyncdiscover. 
It should be a CNAME pointing to webdir.online.lync.com.

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
One or more domain names to check.  This cmdlet accepts pipeline input as well.

## OUTPUTS

## NOTES

## RELATED LINKS

[Test-TeamsRecords]()

[Test-Office365DnsRecords]()

[about_Office365DnsChecker]()

