---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/man/en-US/Test-EntraIDRecords.md
schema: 2.0.0
---

# Test-EntraIDRecords

## SYNOPSIS
Tests all Entra ID DNS records for correctness.

## SYNTAX

```
Test-EntraIDRecords [-DomainName] <String[]> [-Use21Vianet] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will test the Entra ID client configuration, enterprise enrollment, and enterprise registration DNS records for correctness.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-EntraIDRecords contoso.com
```

Verifies that the DNS CNAME records enterprisenrollment.contoso.com, enterpriseregistration.contoso.com, and msoid.contoso.com are correct.

### Example 2
```powershell
PS C:\> "contoso.com","fabrikam.com","tailspintoys.com" | Test-EntraIDRecords
```

Verifies that the three Entra ID records for all three domains are correct.

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
One or more domain names to check.  This cmdlet accepts pipeline input as well.

## OUTPUTS

### Bool
True if all DNS records are correct, false otherwise.  If you pass multiple domain names to this cmdlet, the result will consider all domains;  that is, if contoso.com is correct but fabrikam.com is not, the result will be false.

## NOTES
This cmdlet is the same as running Test-EntraIDClientConfigurationRecord, Test-EntraIDEnterpriseEnrollmentRecord, and Test-EntraIDEnterpriseRegistrationRecord.

Microsoft Entra ID used to be called Microsoft Azure Active Directory, and previous versions of this cmdlet reflected that.

## RELATED LINKS

[Test-EntraIDClientConfigurationRecord]()
[Test-EntraIDEnterpriseEnrollmentRecord]()
[Test-EntraIDEnterpriseRegistrationRecord]()