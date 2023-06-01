<#
Office365DnsChecker 
Copyright (C) 2019-2023 Colin Cogle. All Rights Reserved.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <https://www.gnu.org/licenses/>.
#>

#Requires -Version 5.1
#for automatic variables to detect the OS.

# Set strict mode.
Set-StrictMode -Version Latest

Function Test-Office365DNSRecords
{
	[CmdletBinding()]
	[OutputType([Bool])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseSingularNouns', '',
		Justification='We are testing multiple DNS records.'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[Alias('China')]
		[Switch] $Use21Vianet
	)

	Begin
	{
		$result = $true
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking Office 365 DNS records for $_."
			$result = Test-AzureADRecords -DomainName $_ -Use21Vianet:$Use21Vianet | Out-Null
			$result = Test-ExchangeOnlineRecords -DomainName $_ | Out-Null
			$result = Test-TeamsRecords -DomainName $_ | Out-Null
		}
	}

	End {
		Return $result
	}
}

#region Helper cmdlets
Function Resolve-DNSNameCrossPlatform
{
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[String] $Name,

		[Parameter(Mandatory, Position=1)]
		[ValidateSet('CNAME', 'MX', 'SRV', 'TXT')]
		[String] $Type
	)

	Write-Verbose "Performing a DNS lookup for $Name ($Type)."

	# Check and see if the Resolve-DnsName cmdlet is available.
	# On Windows (Desktop and Core), it is available, and we can use it.
	If (Get-Command Resolve-DnsName -ErrorAction SilentlyContinue)
	{
		$dnsLookup = Resolve-DnsName -Name $Name -Type $Type -ErrorAction SilentlyContinue
		If (-Not $dnsLookup)
		{
			Write-Debug 'DNS record not found.'
			Return $null
		}

		Switch ($Type)
		{
			'CNAME' {
				# For whatever reason, CNAME lookups are returned as a [DnsRecord_PTR] type.  Go figure.
				Return $dnsLookup | Where-Object {$_ -Is [Microsoft.DnsClient.Commands.DnsRecord_PTR]}
			}

			'MX' {
				Return $dnsLookup | Where-Object {$_ -Is [Microsoft.DnsClient.Commands.DnsRecord_MX]}
			}

			'SRV' {
				Return $dnsLookup | Where-Object {$_ -Is [Microsoft.DnsClient.Commands.DnsRecord_SRV]}
			}

			'TXT' {
				Return $dnsLookup | Where-Object {$_ -Is [Microsoft.DnsClient.Commands.DnsRecord_TXT]}
			}
		}
		Return 
	}
	# If Resolve-DnsName is not available, we need to use the system's copy of dig,
	# and try to emulate the style of output that Resolve-DnsName creates.
	Else
	{
		# Remove empty results.
		$dnsLookup = $(/usr/bin/dig -t $Type +short $Name) | Where-Object {$_ -ne ""}
		If (-Not $dnsLookup)
		{
			Write-Debug 'DNS record not found.'
		}

		# To mimic Resolve-DnsName, return results as custom objects with the same properties.
		# For brevity, I'm only implementing the types and members that this module will use.
		Switch ($Type)
		{
			'CNAME' {
				$CNAMEs = @()
				$dnsLookup | ForEach-Object {
					Write-Debug "$Name is a CNAME for $_"
					$CNAMEs += [PSCustomObject]@{
						# dig always returns fully-qualified hostnames.
						# Strip that trailing dot to return results like Resolve-DnsName does.
						'NameHost' = $_ -Replace [RegEx]"\.$"
					}
				}
				Return $CNAMEs
			}

			'MX' {
				$MXs = @()
				$dnsLookup | ForEach-Object {
					$split = -Split $_
					Write-Debug "$Name has the MX record $($split[1]) ($($split[0]))."
					$MXs += [PSCustomObject]@{
						# dig always returns fully-qualified hostnames.
						# Strip that trailing dot to return results like Resolve-DnsName does.
						'NameExchange' = $split[1] -Replace [RegEx]"\.$"
						'Priority'     = $split[0] -As [Int]
					}
				}
				Return $MXs | Sort-Object Priority
			}

			'SRV' {
				$SRVs = @()
				$dnsLookup | ForEach-Object {
					$splits = -Split $_
					
					# dig always returns fully-qualified hostnames.
					# Strip that trailing dot to return results like Resolve-DnsName does.
					$NameTarget = $splits[3] -Replace [RegEx]"\.$" 
					$Priority   = $splits[0] -As [Int]
					$Weight     = $splits[1] -As [Int]
					$Port       = $splits[2] -As [Int]
					Write-Debug "$Name has a SRV record for ${NameTarget}:$Port (priority=$Priority, weight=$Weight)."

					$SRVs += [PSCustomObject]@{
						'Priority'   = $Priority
						'Weight'     = $Weight
						'Port'       = $Port
						'NameTarget' = $NameTarget
					}
				}
				Return $SRVs | Sort-Object Priority, Weight
			}

			'TXT' {
				$TXTs = @()
				$dnsLookup | ForEach-Object {
					Write-Debug "$Name has the TXT record: $_"
					$TXTs += [PSCustomObject]@{
						# dig wraps TXT records in quotes.
						# We need to remove those to emulate Resolve-DnsName.
						'Strings' = ($_ -Replace "^`"" -Replace "`"$")
					}
				}
				Return $TXTs
			}
		}
	}
}

Function Write-Success
{
	Param(
		[Parameter(Position=0)]
		[Alias('Object')]
		[String] $Message,

		[String] $Product
	)

	If ($Product)
	{
		Write-Host -ForegroundColor Green -Object "SUCCESS: ${Product}: $Message"
	}
	Else
	{
		Write-Host -ForegroundColor Green -Object "SUCCESS: $Message"
	}
	
}
#endregion Helper cmdlets

#region Azure AD cmdlets
Function Test-AzureADRecords
{
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseSingularNouns', '',
		Justification='We are testing multiple DNS records.'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[Alias('China')]
		[Switch] $Use21Vianet
	)

	Process
	{
		$DomainName | ForEach-Object {
			Test-AzureADClientConfigurationRecord -DomainName $_ -Use21Vianet:$Use21Vianet
			Test-AzureADEnterpriseEnrollmentRecord -DomainName $_
			Test-AzureADEnterpriseRegistrationRecord -DomainName $_
		}
	}
}

Function Test-AzureADClientConfigurationRecord
{
	[CmdletBinding()]
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[Alias('China')]
		[Switch] $Use21Vianet
	)

	Begin
	{
		$result = $true

		$shouldBe = 'clientconfig.microsoftonline-p.net'
		If ($Use21Vianet) {
			$shouldBe = 'clientconfig.partner.microsoftonline-p.net.cn'
		}
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking client configuration record for $_"

			$record = "msoid.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type CNAME -Name $record

			# As of 2023, the msoid record is no longer required for Office 365
			# services outside of China.  Thus, our code will no longer complain
			# if this DNS record is missing.
			If (-Not $dnsLookup -and -Not $Use21Vianet)
			{
				Write-Success -Product 'Azure AD' 'The client configuration CNAME record is not present.'
			}

			# However, if it exists and is not set to the default value of
			# clientconfig.microsoftonline-p.net, we will still complain.
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				$errorReport = @{
					Message = 'The client configuration DNS record exists, but is not correct.'
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The CNAME record $record was found, but points to the wrong target."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'MsoidCnameIncorrect'
					RecommendedAction = "Change the CNAME record $record to point to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			Else
			{
				If ($Use21Vianet) {
					Write-Success -Product 'Azure AD' 'The client configuration CNAME record is present and correct for 21Vianet.'
				}
				Else {
					Write-Success -Product 'Azure AD' 'The client configuration CNAME record is present, but correct.'
				}
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-AzureADEnterpriseEnrollmentRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin
	{
		$result   = $true
		$shouldBe = 'enterpriseenrollment.manage.microsoft.com'
	}

	Process {
		$DomainName | ForEach-Object {
			Write-Output "Checking AAD enterprise enrollment record for $_"
			$record = "enterpriseenrollment.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type CNAME -Name $record

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = 'The enterprise enrollment DNS record is missing.'
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The DNS record $record was not found."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'EnterpriseEnrollmentCnameMissing'
					RecommendedAction = "Create a CNAME record for $record, pointing to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				$errorReport = @{
					Message = "The enterprise enrollment DNS record exists, but is not correct."
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The DNS record $record was found, but not correct."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'EnterpriseEnrollmentCnameIncorrect'
					RecommendedAction = "Change the CNAME record $record to point to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			Else
			{
				Write-Success -Product 'Azure AD' 'The enterprise enrollment DNS record is correct.'
			}
		}
	}
	
	End {
		Return $result
	}
}

Function Test-AzureADEnterpriseRegistrationRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin
	{
		$result   = $true
		$shouldBe = 'enterpriseregistration.windows.net'
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking AAD enterprise registration record for $_"

			$record = "enterpriseregistration.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type CNAME -Name $record

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = 'The enterprise registration DNS record is missing.'
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The CNAME record $record does not exist."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'EnterpriseRegistrationCnameMissing'
					RecommendedAction = "Create a CNAME record for $record, pointing to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				$errorReport = @{
					Message = "The enterprise registration DNS record exists, but is not correct."
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The CNAME record $record exists, but does not point to the correct target."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'EnterpriseRegistrationCnameIncorrect'
					RecommendedAction = "Change the CNAME record $record to point to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			Else
			{
				Write-Success -Product 'Azure AD' 'The enterprise registration DNS record is correct.'
			}
		}
	}

	End {
		Return $result
	}
}
#endregion Azure AD cmdlets

#region Exchange Online cmdlets
Function Test-ExchangeOnlineRecords
{
	[OutputType([Bool])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseSingularNouns', '',
		Justification='We are testing multiple DNS records.'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[Switch] $GroupByRecord
	)

	Begin {
		$result = $true
	}

	Process
	{
		$DomainName | ForEach-Object {
			$result = Test-ExchangeOnlineMxRecord -DomainName $_
			$result = Test-ExchangeOnlineAutodiscoverRecord -DomainName $_
			$result = Test-ExchangeOnlineSpfRecord -DomainName $_
			$result = Test-ExchangeOnlineSenderIdRecord -DomainName $_
			$result = Test-ExchangeOnlineDkimRecords -DomainName $_
		}
	}

	End {
		Return $result
	}
}

Function Test-ExchangeOnlineAutodiscoverRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String] $DomainName
	)

	Begin
	{
		$result    = $true
		$shouldBe  = 'autodiscover.outlook.com'
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking Exchange Autodiscover records for $_"

			$record    = "autodiscover.$_"
			$dnsLookup = Resolve-DNSNameCrossPlatform -Type CNAME -Name $record
			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = "The Autodiscover DNS CNAME record is missing."
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The CNAME record $record does not exist."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'AutodiscoverCnameMissing'
					RecommendedAction = "Create a CNAME record for $record, pointing to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				$errorReport = @{
					Message = "The Autodiscover DNS CNAME record exists, but is not correct."
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The CNAME record $record was found, but points to the wrong target."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'AutodiscoverCnameMissing'
					RecommendedAction = "Change the CNAME record $record to point to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			Else
			{
				Write-Success -Product 'Exchange Online' 'The Autodiscover DNS CNAME record is correct.'
			}

			$record = "_autodiscover._tcp.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type SRV -Name $record
			If ($dnsLookup)
			{
				$errorReport = @{
					Message = "One or more Autodiscover DNS SRV records exist."
					Category = [System.Management.Automation.ErrorCategory]::ResourceExists
					CategoryReason = "The SRV record $record was found, but should not exist.  They are not compatible with Exchange Online."
					CategoryTargetName = $record
					CategoryTargetType = 'SRV'
					ErrorID = 'AutodiscoverSrvExists'
					RecommendedAction = "Delete all SRV records for $record."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			Else
			{
				Write-Success -Product 'Exchange Online' -Message 'An Autodiscover DNS SRV record does not exist.'
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-ExchangeOnlineDkimRecords
{
	[OutputType([Bool])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseSingularNouns', '',
		Justification='We are testing multiple DNS records.'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[ValidateNotNullOrEmpty()]
		[ValidateSet(1,2)]
		[Int[]] $Selectors = @(1,2)
	)

	Begin {
		$result = $true
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking Exchange Online DKIM records for $_"
			$domain = $_
			ForEach ($i in $Selectors)
			{
				$record         = "selector$i._domainkey.$domain"
				$dnsCnameLookup = Resolve-DnsNameCrossPlatform -Type CNAME -Name $record
				$shouldBeLike   = "selector$i-*._domainkey.*.onmicrosoft.com"
				If (-Not $dnsCnameLookup)
				{
					$errorReport = @{
						Message = "The DKIM CNAME record for selector$i is missing."
						Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
						CategoryReason = "The DNS record $record was not found."
						CategoryTargetName = $record
						CategoryTargetType = 'CNAME'
						ErrorID = "DkimSelector${i}CnameMissing"
						RecommendedAction = "Create a CNAME record for $record.  Look in the Exchange Admin Center to find the target."
						TargetObject = $dnsCnameLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
				ElseIf ($dnsCnameLookup.NameHost -NotLike $shouldBeLike)
				{
					Write-Output $dnsCnameLookup
					$errorReport = @{
						Message = "The DKIM CNAME record for selector$i exists, but is incorrect."
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The DNS record $record was found, but incorrect."
						CategoryTargetName = $record
						CategoryTargetType = 'CNAME'
						ErrorID = "DkimSelector${i}CnameIncorrect"
						RecommendedAction = "Change the CNAME record $record to point to the correct name, usually `"contoso-com._domainkey.contoso.onmicrosoft.com`".  Look in the Exchange Admin Center to find the exact target."
						TargetObject = $dnsCnameLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
				Else
				{
					$dnsTxtLookup  = Resolve-DnsNameCrossPlatform -Type TXT -Name $record
					$dnsTxtRecords = $null

					# Wrapping this in a null check to avoid strict mode warnings.
					If ($null -ne $dnsTxtLookup)
					{
						$dnsTxtRecords = $dnsTxtLookup | Where-Object {$_.Strings -NotMatch $shouldBeLike}
					}

					If (-Not $dnsTxtLookup)
					{
						$errorReport = @{
							Message = "The DKIM CNAME record exists, but the TXT record for selector$i is missing."
							Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
							CategoryReason = "The DNS TXT record $record was not found."
							CategoryTargetName = $record
							CategoryTargetType = 'TXT'
							ErrorID = "DkimSelector${i}TxtMissing"
							RecommendedAction = 'Use the Exchange Admin Center or New-DkimSigningConfig to generate a new key pair.'
							TargetObject = $dnsTxtLookup
						}
						Write-Error @errorReport
						Write-Information $errorReport.RecommendedAction
						$result = $false
						Continue
					}

					If (($dnsTxtRecords | Measure-Object).Count -gt 1)
					{
						If ($dnsTxtRecords[0] -Match $DomainName)
						{
							$dnsTxtRecords[0].Strings = $dnsTxtRecords[1].Strings
						}
						Else
						{
							$errorReport = @{
								Message = "Multiple DKIM TXT records for selector$i were found."
								Category = [System.Management.Automation.ErrorCategory]::InvalidData
								CategoryReason = "The DNS TXT record that $record points to was found, but returned multiple records."
								CategoryTargetName = $record
								CategoryTargetType = 'TXT'
								ErrorID = "DkimSelector${i}TxtTooManyResults"
								RecommendedAction = 'Try regenerating the DKIM key.'
								TargetObject = $dnsTxtLookup
							}
							Write-Error @errorReport
							Write-Information $errorReport.RecommendedAction
							$result = $false
							Continue
						}
					}

					# Sometimes, the TXT record will wrap into two records, depending on the DNS server.
					# Check them both, just to be sure.
					If ($dnsTxtRecords[0].Strings -NotLike 'v=DKIM1;*' -and $dnsTxtRecords[0].Strings[0] -NotLike 'v=DKIM1;*')
					{
						$errorReport = @{
							Message = "The DKIM TXT record for selector$i is not a valid key."
							Category = [System.Management.Automation.ErrorCategory]::InvalidData
							CategoryReason = "The DNS TXT record that $record points to was found, but is not a valid DKIM key."
							CategoryTargetName = $record
							CategoryTargetType = 'TXT'
							ErrorID = "DkimSelector${i}TxtIncorrect"
							RecommendedAction = 'Regenerate the DKIM key.'
							TargetObject = $dnsTxtLookup
						}
						Write-Error @errorReport
						Write-Information $errorReport.RecommendedAction
						$result = $false
						Continue
					}

					Write-Success -Product 'Exchange Online' "The DKIM key selector$i appears to be correct."
				}
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-ExchangeOnlineMxRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin {
		# Note that there are valid reasons why we might not be using
		# Microsoft's MX record.  Warnings will not set $result to $false.
		$result = $true
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking MX records for $_"
			$dnsLookup = $null   # this is to not upset StrictMode.
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type 'MX' $_

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = "No MX records were found for the domain $_."
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The MX record for $_ was not found."
					CategoryTargetName = $_
					CategoryTargetType = 'MX'
					ErrorID = 'MxRecordMissing'
					RecommendedAction = "Add an MX record for $_.  The mail exchanger should be the value you see in the Microsoft 365 Admin Center (usually `"contoso-com.mail.protection.outlook.com`")."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf (($dnsLookup | Measure-Object | Select-Object -ExpandProperty Count) -eq 1)
			{
				Write-Success -Product 'Exchange Online' "Exactly one MX record was found for the domain $_."
			}
			Else
			{
				Write-Warning "More than one MX record was found for the domain $_."
				$dnsLookup | ForEach-Object {Write-Debug $_}
			}

			If ($null -ne $dnsLookup)
			{
				If ($dnsLookup[0].NameExchange -Like '*.mail.protection.outlook.com')
				{
					Write-Success -Product 'Exchange Online' "The first MX record for the domain $_ appears correct."
				}
				Else
				{
					Write-Warning "The first MX record for the doamin $_ does not appear to be correct.  If you are using a third-party spam filter, this is normal."
				}
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-ExchangeOnlineSenderIdRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Return (Test-ExchangeOnlineSpfRecord -DomainName $DomainName -SpfOrSenderID 'Sender ID')
}

Function Test-ExchangeOnlineSpfRecord
{
	[CmdletBinding()]
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName,

		[ValidateSet('SPF', 'Sender ID')]
		[String] $SpfOrSenderID = 'SPF'
	)

	Begin
	{
		$result = $true

		If ($SpfOrSenderID -eq 'SPF')
		{
			$ErrorCode = 'SPF'
		}
		Else
		{
			$ErrorCode = 'SenderId'
		}
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Performing $SpfOrSenderId checks for $_."

			$dnsLookup = Resolve-DnsNameCrossPlatform -Type TXT -Name $_ | Where-Object {
				# As per the RFC's, all SPF/Sender ID tokens are case-insensitive.
				($_.Strings -Like 'v=spf1 *' -and $SpfOrSenderId -Eq 'SPF') -or `
				($_.Strings -Like 'spf2.0/*' -and $SpfOrSenderId -Eq 'Sender ID')
			}

			If (-Not $dnsLookup) {
				# Sender ID records are pretty much non-existent.
				# If we don't find one, don't bother showing an error.
				If ($SpfOrSenderID -eq 'Sender ID')
				{
					Write-Verbose 'No Sender ID record was found.  This is fine.'
				}
				Else
				{
					$errorReport = @{
						Message = 'No SPF TXT record was found.'
						Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
						CategoryReason = "No SPF TXT record could be found for the domain $_."
						CategoryTargetName = $_
						CategoryTargetType = 'TXT'
						ErrorID = 'SpfRecordMissing'
						RecommendedAction = "Create an SPF TXT record for $_."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
			}
			ElseIf (($dnsLookup | Measure-Object | Select-Object -ExpandProperty Count) -gt 1)
			{
				Write-Warning "More than one $SpfOrSenderID record was found.  Anti-spam filters' behavior may not be as expected."
				Write-Verbose "Only the first $SpfOrSenderID record will be evaluated."
			}
			Else
			{
				Write-Success -Product 'Exchange Online' "Exactly one $SpfOrSenderID record was found."

				$tokens = -Split ($dnsLookup[0].Strings)
				$correctToken  = 'include:spf.protection.outlook.com'

				If ($correctToken -In $tokens -or "+$correctToken" -In $tokens)
				{
					Write-Success -Product 'Exchange Online' "The correct $SpfOrSenderID passing token was found"
				}
				ElseIf ("-$correctToken" -In $Tokens)
				{
					$errorReport = @{
						Message = "The $SpfOrSenderID token was found, but marked as a hard failure."
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The token -$correctToken was found in the $SpfOrSenderID record, which fails all mail from Exchange Online."
						CategoryTargetName = "-$correctToken"
						CategoryTargetType = "${ErrorCode}Token"
						ErrorID = "${ErrorCode}RecordExchangeOnlineSetToHardFail"
						RecommendedAction = "In the $SpfOrSenderID record, remove the leading '-' before $correctToken."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
				ElseIf ("~$correctToken" -In $tokens)
				{
					$errorReport = @{
						Message = "The $SpfOrSenderID token was found, but marked as a soft failure."
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The token ~$correctToken was found in the $SpfOrSenderID record, which may fail all mail from Exchange Online."
						CategoryTargetName = "~$correctToken"
						CategoryTargetType = "${ErrorCode}Token"
						ErrorID = "${ErrorCode}RecordExchangeOnlineSetToSoftFail"
						RecommendedAction = "In the $SpfOrSenderID record, remove the leading '~' before $correctToken."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
				ElseIf ("-$correctToken" -In $tokens)
				{
					$errorReport = @{
						Message = "The $SpfOrSenderID token was found, but marked as neutral."
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The token ?$correctToken was found in the $SpfOrSenderID record, which makes no assertion about mail from Exchange Online."
						CategoryTargetName = "?$correctToken"
						CategoryTargetType = "${ErrorCode}Token"
						ErrorID = "${ErrorCode}RecordExchangeOnlineSetToNeutral"
						RecommendedAction = "In the $SpfOrSenderID record, remove the leading '?' before $correctToken."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
				Else
				{
					$errorReport = @{
						Message = "The $SpfOrSenderID record was found, but is missing the token for Exchange Online."
						Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
						CategoryReason = "The token $correctToken was not found in the SPF record."
						CategoryTargetName = $_
						CategoryTargetType = 'TXT'
						ErrorID = "${ErrorCode}RecordExchangeOnlineMissing"
						RecommendedAction = "Add the token $correctToken to the $SpfOrSenderID record."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
			}
		}
	}

	End {
		Return $result
	}
}
#endregion Exchange Online cmdlets

#region Teams/Skype for Business Online cmdlets
Function Test-TeamsRecords
{
	[CmdletBinding()]
	[OutputType([Bool])]
	[Alias(
		'Test-LyncRecords',
		'Test-SkypeForBusinessRecords',
		'Test-SkypeForBusinessOnlineRecords'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
		'PSUseSingularNouns', '',
		Justification='We are testing multiple DNS records.'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin {
		$result = $true
	}

	Process {
		$DomainName | ForEach-Object {
			$result = Test-TeamsAutodiscoverRecord -DomainName $_
			$result = Test-TeamsSipCnameRecord -DomainName $_
			$result = Test-TeamsSipSrvRecord -DomainName $_
			$result = Test-TeamsSipFederationSrvRecord -DomainName $_
		}
	}

	End {
		Return $result
	}
}

Function Test-TeamsAutodiscoverRecord
{
	[OutputType([Bool])]
	[Alias(
		'Test-LyncDiscoverRecord',
		'Test-LyncAutodiscoverRecord',
		'Test-SkypeForBusinessAutodiscoverRecord',
		'Test-SkypeForBusinessOnlineAutodiscoverRecord'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)
	
	Begin
	{
		$result   = $true
		$shouldBe = 'webdir.online.lync.com'
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Verifying the Teams/Skype autodiscover record for $_"

			$dnsLookup = Resolve-DnsNameCrossPlatform -Type CNAME -Name "lyncdiscover.$_" -ErrorAction SilentlyContinue
			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = 'The Skype/Teams Autodiscover DNS record is missing.'
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The CNAME record lyncdiscover.$_ does not exist."
					CategoryTargetName = "lyncdiscover.$_"
					CategoryTargetType = 'CNAME'
					ErrorID = 'LyncDiscoverCnameMissing'
					RecommendedAction = "Create a CNAME record for lyncdiscover.$_, pointing to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				Write-Warning -Message 'The Skype/Teams autodiscover DNS record exists, but is not correct.  This may be intentional, if you have a Skype for Business Server deployment.'
			}
			Else
			{
				Write-Success -Product 'Teams/Skype' 'The autodiscover DNS record is correct.'
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-TeamsSipCnameRecord
{
	[OutputType([Bool])]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin
	{
		$result   = $true
		$shouldBe = 'sipdir.online.lync.com'
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking the SIP CNAME record for $_"

			$record = "sip.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type 'CNAME' -Name $record

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = "The SIP DNS CNAME record is missing for $_."
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "The CNAME record $record does not exist."
					CategoryTargetName = $record
					CategoryTargetType = 'CNAME'
					ErrorID = 'SipCnameMissing'
					RecommendedAction = "Create a CNAME record for $record, pointing to $shouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup.NameHost -ne $shouldBe)
			{
				Write-Warning -Message "The SIP CNAME record exists for $_, but is not correct.  This may be intentional, if you have a Skype for Business Server deployment."
			}
			Else
			{
				Write-Success -Product 'Teams/Skype' "The SIP CNAME record is correct for $_."
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-TeamsSipFederationSrvRecord
{
	[OutputType([Bool])]
	[Alias(
		'Test-LyncSipFederationRecord',
		'Test-SkypeForBusinessSipFederationSrvRecord',
		'Test-SkypeForBusinessOnlineSipFederationRecord'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin
	{
		$result         = $true
		$targetShouldBe = 'sipfed.online.lync.com'
		$portShouldBe   = 5061
	}

	Process
	{
		$DomainName | ForEach-Object {
			$record = "_sipfederationtls._tcp.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type 'SRV' -Name $record

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = 'The SIP federation SRV record is missing.'
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "A SRV record for $record was not found."
					CategoryTargetName = $record
					CategoryTargetType = 'SRV'
					ErrorID = 'SipFederationSrvMissing'
					RecommendedAction = "Create a SRV record for $record (port $portShouldBe) pointing to $targetShouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf (($dnsLookup | Measure-Object | Select-Object -ExpandProperty Count) -gt 1)
			{
				$errorReport = @{
					Message = 'Multiple SIP federation SRV records exist.'
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The SRV record $record returned multiple records."
					CategoryTargetName = $record
					CategoryTargetType = 'SRV'
					ErrorID = 'SipFederationSrvTooManyResults'
					RecommendedAction = "Delete any extra SRV records for $record."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup[0].NameTarget -ne $targetShouldBe -or $dnsLookup[0].Port -ne $portShouldBe)
			{
				If ($dnsLookup[0].NameTarget -ne $targetShouldBe)
				{
					$errorReport = @{
						Message = 'The SIP federation SRV record was found, but has the incorrect target.'
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The DNS SRV record $record was found, but has the incorrect target."
						CategoryTargetName = $record
						CategoryTargetType = 'SRV'
						ErrorID = 'SipFederationSrvIncorrectTarget'
						RecommendedAction = "Change the SRV record for $record to point to $targetShouldBe."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}

				If ($dnsLookup[0].Port -ne $portShouldBe)
				{
					$errorReport = @{
						Message = 'the SIP federation SRV record was found, but has the incorrect port.'
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The DNS SRV record $record was found, but has the incorrect port."
						CategoryTargetName = $record
						CategoryTargetType = 'SRV'
						ErrorID = 'sipFederationSrvIncorrectPort'
						RecommendedAction = "Change the SRV record for $record to point to port $portShouldBe."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
			}
			Else
			{
				Write-Success -Product 'Teams/Skype' 'The SIP federation SRV record is correct.'
			}
		}
	}

	End {
		Return $result
	}
}

Function Test-TeamsSipSrvRecord
{
	[OutputType([Bool])]
	[Alias(
		'Test-LyncSipSrvRecord',
		'Test-SkypeForBusinessSipSrvRecord',
		'Test-SkypeForBusinessOnlineSipSrvRecord'
	)]
	Param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[Alias('Name')]
		[ValidateNotNullOrEmpty()]
		[String[]] $DomainName
	)

	Begin
	{
		$result         = $true
		$targetShouldBe = 'sipdir.online.lync.com'
		$portShouldBe   = 443
	}

	Process
	{
		$DomainName | ForEach-Object {
			Write-Output "Checking the SIP/TLS service record for $_"

			$record = "_sip._tls.$_"
			$dnsLookup = Resolve-DnsNameCrossPlatform -Type 'SRV' -Name $record

			If (-Not $dnsLookup)
			{
				$errorReport = @{
					Message = 'The SIP/TLS SRV record is missing.'
					Category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
					CategoryReason = "A SRV record for $record was not found."
					CategoryTargetName = $record
					CategoryTargetType = 'SRV'
					ErrorID = 'SipSrvMissing'
					RecommendedAction = "Create a SRV record for $record (port $portShouldBe) pointing to $targetShouldBe."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf (($dnsLookup | Measure-Object | Select-Object -ExpandProperty Count) -gt 1)
			{
				$errorReport = @{
					Message = 'Multiple SIP/TLS SRV records exist.'
					Category = [System.Management.Automation.ErrorCategory]::InvalidData
					CategoryReason = "The SRV record $record returned multiple records."
					CategoryTargetName = $record
					CategoryTargetType = 'SRV'
					ErrorID = 'SipSrvTooManyResults'
					RecommendedAction = "Delete any extra SRV records for $record."
					TargetObject = $dnsLookup
				}
				Write-Error @errorReport
				Write-Information $errorReport.RecommendedAction
				$result = $false
			}
			ElseIf ($dnsLookup[0].NameTarget -ne $targetShouldBe -or $dnsLookup[0].Port -ne $portShouldBe)
			{
				If ($dnsLookup[0].NameTarget -ne $targetShouldBe)
				{
					$errorReport = @{
						Message = 'The SIP/TLS SRV record was found, but has the incorrect target.'
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The DNS SRV record $record was found, but has the incorrect target."
						CategoryTargetName = $record
						CategoryTargetType = 'SRV'
						ErrorID = 'SipSrvIncorrectTarget'
						RecommendedAction = "Change the SRV record for $record to point to $targetShouldBe."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}

				If ($dnsLookup[0].Port -ne $portShouldBe)
				{
					$errorReport = @{
						Message = 'The SIP/TLS SRV record was found, but has the incorrect port.'
						Category = [System.Management.Automation.ErrorCategory]::InvalidData
						CategoryReason = "The DNS SRV record $record was found, but has the incorrect port."
						CategoryTargetName = $record
						CategoryTargetType = 'SRV'
						ErrorID = 'SipSrvIncorrectPort'
						RecommendedAction = "Change the SRV record for $record to point to port $portShouldBe."
						TargetObject = $dnsLookup
					}
					Write-Error @errorReport
					Write-Information $errorReport.RecommendedAction
					$result = $false
				}
			}
			Else
			{
				Write-Success -Product 'Teams/Skype' 'The SIP/TLS SRV record is correct.'
			}
		}
	}

	End {
		Return $result
	}
}
#endregion Teams/Skype for Business Online cmdlets
