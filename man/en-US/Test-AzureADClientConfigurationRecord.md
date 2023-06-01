---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-AzureADClientConfigurationRecord.md
schema: 2.0.0
---

# Test-AzureADClientConfigurationRecord

## SYNOPSIS
Verifies that a domain's Azure AD client configuration DNS record is correct.

## SYNTAX

```
Test-AzureADClientConfigurationRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Azure Active Directory client configuration DNS record, named msoid.  It should be a CNAME pointing to clientconfig.microsoftonline-p.net.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-AzureADClientConfigurationRecord contoso.com
```

Verifies that the DNS CNAME record msoid.contoso.com is correct.

### Example 2
```powershell
PS C:\> "contoso.com","fabrikam.com","tailspintoys.com" | Test-AzureADClientConfigurationRecord
```

Verifies that the DNS CNAME records msoid.contoso.com, msoid.fabrikam.com, and msoid.tailspintoys.com are correct.

## PARAMETERS

### -DomainName
One or more domain names to check.  This cmdlet accepts pipeline input as well.

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

### System.Object

## NOTES

## RELATED LINKS
[Test-AzureADJoinRecords]()
[Test-Office365DnsRecords]()
[about_Office365DnsChecker]()