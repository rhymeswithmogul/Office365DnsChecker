---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-AzureADClientConfigurationRecord.md
schema: 2.0.0
---

# Test-AzureADClientConfigurationRecord

## SYNOPSIS
Verifies that a domain's Azure AD client configuration DNS record is correct.

## SYNTAX

```
Test-AzureADClientConfigurationRecord [-DomainName] <String[]> [-Use21Vianet] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Azure Active Directory client configuration DNS record, named msoid.  It should not be present, or if so, be a CNAME pointing to clientconfig.microsoftonline-p.net.

For Office 365 tenants in China operated by 21Vianet, the msoid record must be present and set to clientconfig.partner.microsoftonline-p.net.cn.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-AzureADClientConfigurationRecord contoso.com
```

Verifies that the DNS CNAME record msoid.contoso.com is correct or missing.

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

### -Use21Vianet
If your Office 365 tenant is hosted by 21Vianet, include this switch.  Chinese customers must have the msoid attribute set to a special value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: China

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
One or more domain names to check.  This cmdlet accepts pipeline input as well.

## OUTPUTS

### System.Object

## NOTES
Starting in early 2023, Microsoft's recommendations changed.  Now, the msoid record should not be defined for any tenants not operated by 21Vianet.  For more information, see:
https://learn.microsoft.com/en-gb/microsoft-365/admin/services-in-china/purpose-of-cname?view=o365-21vianet

## RELATED LINKS

[Test-AzureADJoinRecords]()
[Test-Office365DnsRecords]()
[about_Office365DnsChecker]()