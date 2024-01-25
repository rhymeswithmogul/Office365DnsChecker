---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-ExchangeOnlineSpfRecord.md
schema: 2.0.0
---

# Test-ExchangeOnlineSpfRecord

## SYNOPSIS
Verifies that a domain's SPF record is compatible with Exchange Online.

## SYNTAX

```
Test-ExchangeOnlineSpfRecord [-DomainName] <String[]> [[-SpfOrSenderID] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks for the presence and correctness of the SPF TXT record, and makes sure that the SPF token for Exchange Online (include:spf.protection.outlook.com) is allowing mail.

This cmdlet is not meant to be a comprehensive SPF test. It only ensures that the Exchange Online token is present and set to pass. It does not check for other errors like typos, excessive DNS lookups, records stored as the deprecated SPF RR type, or any other issue that might cause a TempError or PermError. For more information about Sender Policy Framework, please read RFC 7208.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineSpfRecord contoso.com
```

Verifies that the SPF record for contoso.com is present and contains the token "include:spf.protection.outlook.com" with a pass qualifier.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-ExchangeOnlineSpfRecord
```

Verifies that the SPF records for contoso.com, fabrikam.com, and tailspintoys.com are present and contain the token "include:spf.protection.outlook.com" with a pass qualifier.

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

### -SpfOrSenderID
By default, this cmdlet will check a domain's SPF record.  To check the deprecated Sender ID record, write Sender ID here.

This switch is reserved for internal use, and should not be used by end users.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: SPF, Sender ID

Required: False
Position: 1
Default value: SPF
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
When SPF was first introduced, it was intended that you put your SPF record into a DNS resource record of type SPF (99).  This was deprecated in favor of the SPF TXT record.  It is no longer recommended to have an SPF record with RR type SPF.  Due to limitations, this cmdlet is only capable of evaluating the record type that matters, the TXT record.

## RELATED LINKS

[Test-ExchangeOnlineRecords]()

[Test-ExchangeOnlineSenderIdRecord]()

[Test-Office365DnsRecords]()

[about_Office365DnsChecker]()

