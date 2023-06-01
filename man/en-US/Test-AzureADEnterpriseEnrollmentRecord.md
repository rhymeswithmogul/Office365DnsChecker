---
external help file: Office365DnsChecker-help.xml
Module Name: Office365DnsChecker
online version: https://github.com/rhymeswithmogul/Office365DNSChecker/blob/master/man/en-US/Test-AzureADEnteprriseEnrollmentRecord.md
schema: 2.0.0
---

# Test-AzureADEnterpriseEnrollmentRecord

## SYNOPSIS
Verifies that a domain's Azure AD enterprise enrollment DNS record is correct.

## SYNTAX

```
Test-AzureADEnterpriseEnrollmentRecord [-DomainName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet checks one or more domains for the presence and correctness of the Azure Active Directory enterprise enrollment DNS record, named enterpriseenrollment.  It should be a CNAME pointing to enterpriseenrollment.manage.microsoft.com.

## EXAMPLES

### EXAMPLE 1
```
C:\PS> Test-AzureADEnterpriseEnrollmentRecord contoso.com
```

Verifies that the DNS CNAME record enterpriseenrollment.contoso.com is correct.

### EXAMPLE 2
```
C:\PS> "contoso.com","fabrikam.com","tailspintoys.com" | Test-AzureADEnterpriseEnrollmentRecord
```

Verifies that the DNS CNAME records enterpriseenrollment.contoso.com, enterpriseenrollment.fabrikam.com, and enterpriseenrollment.tailspintoys.com are correct.

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
## OUTPUTS

## NOTES

## RELATED LINKS

[Test-AzureADJoinRecords]()

[Test-Office365DnsRecords]()

[about_Office365DnsChecker]()

