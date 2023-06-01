---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-AzureADRecords.md
schema: 2.0.0
---

# Test-AzureADRecords

## SYNOPSIS
Tests all Azure AD DNS records for correctness.

## SYNTAX

```
Test-AzureADRecords [-DomainName] <String[]> [-Use21Vianet] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will test the Azure Active Directory client configuration, enterprise enrollment, and enterprise registration DNS records for correctness.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-AzureADRecords contoso.com
```

Verifies that the DNS CNAME records enterprisenrollment.contoso.com, enterpriseregistration.contoso.com, and msoid.contoso.com are correct.

### Example 2
```powershell
PS C:\> "contoso.com","fabrikam.com","tailspintoys.com" | Test-AzureADRecords
```

Verifies that the three Azure AD records for all three domains are correct.

## PARAMETERS

### -DomainName
One or more domain names to check.  This cmdlet accepts pipeline input as well.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
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
One or more domain names to check.

## OUTPUTS

### System.Object

## NOTES
This cmdlet is the same as running Test-AzureADClientConfigurationRecord, Test-AzureADEnterpriseEnrollmentRecord, and Test-AzureADEnterpriseRegistrationRecord.

## RELATED LINKS

[Test-AzureADClientConfigurationRecord]()
[Test-AzureADEnterpriseEnrollmentRecord]()
[Test-AzureADEnterpriseRegistrationRecord]()