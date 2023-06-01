---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-ExchangeOnlineMxRecord.md
schema: 2.0.0
---

# Test-ExchangeOnlineMxRecord

## SYNOPSIS
Verifies that a domain's MX record is correct.

## SYNTAX

```
Test-ExchangeOnlineMxRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains' DNS records for the presence and correctness of the Exchange Online MX record.  The first and only MX record should look something like tenantdomain-com.mail.protection.outlook.com.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineMxRecord contoso.com
```

Verifies that the MX record(s) for contoso.com deliver mail to Exchange Online.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-ExchangeOnlineMxRecord
```

Verifies that the MX records for contoso.com, fabrikam.com, and tailspintoys.com deliver mail to Exchange Online.

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
This cmdlet will not print an error if the MX records are incorrect; it will only print a warning.  Some people may choose to use additional spam filtering in front of Exchange Online, so it is possible to have a working Exchange Online setup even with "wrong" MX records.  Alternatively, a hybrid Exchange deployment may choose to deliver email to the on-premises server instead of to Exchange Online.  Use your best judgement when reviewing this cmdlet's output.

## RELATED LINKS

[Test-Office365DnsRecords]()

[Test-ExchangeOnlineRecords]()

[about_Office365DnsChecker]()

