---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-ExchangeOnlineRecords.md
schema: 2.0.0
---

# Test-ExchangeOnlineRecords

## SYNOPSIS
Verifies a domain's Exchange Online DNS records are all correct.

## SYNTAX

```
Test-ExchangeOnlineRecords [-DomainName] <String[]> [-GroupByRecord] [-DANERequired] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains' DNS records for the presence and correctness of Exchange Online's DNS records. These include the Autodiscover CNAME, the DKIM CNAME and TXT records, the MX record, the SPF TXT record, and the Sender ID TXT record (if present).

As some people choose to use a third-party spam filter with Office 365, this cmdlet will print a warning instead of an error if the MX records are incorrect.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineRecords contoso.com
```

This will verify that the CNAME autodiscover.contoso.com is correct, the two DKIM CNAME and TXT records selector1._domainkey.contoso.com and selector2._domainkey.contoso.com are correct and valid, the MX record for contoso.com points to Exchange Online, the SPF TXT record for contoso.com is present and contains the Exchange Online include token, and the Sender ID record for contoso.com (if present) contains the include token for Exchange Online.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-AzureADClientConfigurationRecord
```

For each domain, this will verify that the Autodiscover CNAME is correct, the two DKIM CNAME and TXT records are correct and valid, the MX record points to Exchange Online, the SPF record is present and contains the Exchange Online include: token, and the Sender ID record (if present) contains the include: token for Exchange Online.

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

### -GroupByRecord
{{ Fill GroupByRecord Description }}

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

### -DANERequired
Specify this switch to print a warning if the DNSSEC/DANE-enabled MX endpoints are not in use.  Without this switch, either the non-secure or secure MX names will be considered good.

The DNSSEC/DANE-enabled endpoints will not be available for use until March 2024, with general availability in July 2024.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
One or more domain names to check. 
This cmdlet accepts pipeline input as well.

## OUTPUTS

## NOTES

## RELATED LINKS

[Test-ExchangeOnlineAutodiscoverRecord]()

[Test-ExchangeOnlineDkimRecords]()

[Test-ExchangeOnlineSenderIdRecord]()

[Test-ExchangeOnlineMxRecord]()

[Test-ExchangeOnlineSpfRecord]()

[about_Office365DnsChecker]()

[Test-Office365DnsRecords]()

