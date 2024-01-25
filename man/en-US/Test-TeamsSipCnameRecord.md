---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-TeamsSipCnameRecord.md
schema: 2.0.0
---

# Test-TeamsSipCnameRecord

## SYNOPSIS
Verifies that a domain's Teams/Skype for Business SIP CNAME record is correct.

## SYNTAX

```
Test-TeamsSipCnameRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Microsoft Teams/Skype for Business Online SIP CNAME record, named sip.  It should be a CNAME pointing to sipdir.online.lync.com.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-TeamsSipCnameRecord contoso.com
```

Verifies that the DNS CNAME record sip.contoso.com is correct.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-TeamsSipCnameRecord
```

Verifies that the DNS CNAME records sip.contoso.com, sip.fabrikam.com, and sip.tailspintoys.com are correct.

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

### Bool
True if all DNS records are correct, false otherwise.  If you pass multiple domain names to this cmdlet, the result will consider all domains;  that is, if contoso.com is correct but fabrikam.com is not, the result will be false.

## NOTES

## RELATED LINKS

[Test-TeamsRecords]()

[Test-Office365DnsRecords]()

[about_Office365DnsChecker]()

