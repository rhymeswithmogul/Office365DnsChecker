---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-ExchangeOnlineDkimRecords.md
schema: 2.0.0
---

# Test-ExchangeOnlineDkimRecords

## SYNOPSIS
Verifies that a domain's Exchange Online DKIM records are correct.

## SYNTAX

```
Test-ExchangeOnlineDkimRecords [-DomainName] <String[]> [[-Selectors] <Int32[]>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains' DNS records for the presence and correctness of the two Exchange Online DKIM records, named selector1 and selector2.  Each should be a CNAME to the corresponding TXT record under _domainkey.tenantname.onmicrosoft.com (the Exchange Admin Center will tell you what your domain's DKIM key record is named).

The TXT records returned are also checked to see if they are valid DKIM key records.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-ExchangeOnlineDkimRecords contoso.com
```

Verifies that the two CNAME records selector1._domainkey.contoso.com and selector2._domainkey.contoso.com point to a DKIM record under *.onmicrosoft.com, and that the TXT records appear to be valid DKIM key records.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com" | Test-AzureADClientConfigurationRecord
```

Verifies that the CNAME records selector1._domainkey.contoso.com, selector2._domainkey.contoso.com, selector1._domainkey.fabrikam.com, and selector2._domainkey.fabrikam.com each point to a DKIM record under *.onmicrosoft.com; and that the TXT records appear to be valid DKIM key records.

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

### -Selectors
Exchange Online requires both selector1 and selector2 to exist. 
However, if you would like to check only one of the keys, specify its number here.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:
Accepted values: 1, 2

Required: False
Position: 1
Default value: 1,2
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
This cmdlet only checks for the presence of what should be a valid DKIM key (that is, a TXT record starting with "v=DKIM1;"). It does not check the record for validity or correctness beyond that.

## RELATED LINKS

[Get-DkimSigningConfig]()

[New-DkimSigningConfig]()

[about_Office365DnsChecker]()

[Test-ExchangeOnlineRecords]()

[Test-Office365DnsRecords]()

