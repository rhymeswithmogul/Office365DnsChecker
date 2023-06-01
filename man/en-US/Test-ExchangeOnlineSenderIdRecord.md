---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-ExchangeOnlineSenderIdRecord.md
schema: 2.0.0
---

# Test-ExchangeOnlineSenderIdRecord

## SYNOPSIS
Verifies that a domain's Sender ID record, if present, is compatible with Exchange Online.

## SYNTAX

```
Test-ExchangeOnlineSenderIdRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks for the presence and correctness of a Sender ID record, and makes sure that the token for Exchange Online (include:spf.protection.outlook.com) is allowing mail.

This cmdlet is not meant to be a comprehensive Sender ID test. It only ensures that the Exchange Online token is present and set to pass. It does not check for other errors like typos, excessive DNS lookups, mis-use of the "mfrom" and/or "pra" mechanisms, or any other issue that might cause a TempError or PermError.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineSenderIdRecord contoso.com
```

Verifies that the Sender ID record for contoso.com is either absent or contains the token "include:spf.protection.outlook.com" with a pass qualifier.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-ExchangeOnlineSenderIdRecord
```

Verifies that the Sender ID records for contoso.com, fabrikam.com, and tailspintoys.com are either absent or contain the token "include:spf.protection.outlook.com" with a pass qualifier.

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
Sender ID records are considered obsolete, in favor of SPF (TXT) records.  You do not need to publish one, and absence of one will not cause this cmdlet print an error. In fact, *not* publishing one is considered best practice.

However, if you *do* choose to publish a Sender ID record, this cmdlet will do its best to ensure that it is correct.

## RELATED LINKS

[about_Office365DnsChecker]()

[Test-Office365DnsRecords]()

[Test-ExchangeOnlineSpfRecord]()

[Test-ExchangeOnlineRecords]()

