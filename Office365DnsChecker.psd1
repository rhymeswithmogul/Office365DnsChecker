#
# Module manifest for module 'Office365DNSChecker'
#
# Generated by: Colin Cogle
#
# Generated on: 11/5/2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'src/Office365DnsChecker.psm1'

# Version number of this module.
ModuleVersion = '1.2.0'

# Supported PSEditions
CompatiblePSEditions = @('Core', 'Desktop')

# ID used to uniquely identify this module
GUID = 'a3186ece-3435-4ab3-a075-25c645014036'

# Author of this module
Author = 'Colin Cogle <colin@colincogle.name>'

# Company or vendor of this module
# CompanyName = $null

# Copyright statement for this module
Copyright = '(c) 2019-2023 Colin Cogle. All rights reserved. Licensed under the GPL version 3.'

# Description of the functionality provided by this module
Description = "Checks a domain's Office 365 DNS records for correctness."

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
	'Test-Office365DNSRecords',
	'Test-AzureADRecords',
	'Test-ExchangeOnlineRecords',
	'Test-TeamsRecords',
	'Test-AzureADClientConfigurationRecord',
	'Test-AzureADEnterpriseEnrollmentRecord',
	'Test-AzureADEnterpriseRegistrationRecord',
	'Test-ExchangeOnlineAutodiscoverRecord',
	'Test-ExchangeOnlineDkimRecords',
	'Test-ExchangeOnlineMxRecord',
	'Test-ExchangeOnlineSenderIdRecord',
	'Test-ExchangeOnlineSpfRecord',
	'Test-TeamsAutodiscoverRecord',
	'Test-TeamsSipCnameRecord',
	'Test-TeamsSipSrvRecord',
	'Test-TeamsSipFederationSrvRecord'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
	'Test-LyncRecords',
	'Test-SkypeForBusinessRecords',
	'Test-SkypeForBusinessOnlineRecords',
	'Test-LyncSipCnameRecord',
	'Test-SkypeForBusinessSipCnameRecord',
	'Test-SkypeForBusinessOnlineSipCnameRecord',
	'Test-LyncSipSrvRecord',
	'Test-SkypeForBusinessSipSrvRecord',
	'Test-SkypeForBusinessOnlineSipSrvRecord',
	'Test-LyncDiscoverRecord',
	'Test-LyncAutodiscoverRecord',
	'Test-SkypeForBusinessAutodiscoverRecord',
	'Test-SkypeForBusinessOnlineAutodiscoverRecord',
	'Test-LyncSipFederationSrvRecord',
	'Test-SkypeForBusinessSipFederationSrvRecord',
	'Test-SkypeForBusinessOnlineSipFederationSrvRecord'
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
	'en-US/about_Office365DnsChecker.Help.txt',
	'en-US/Office365DnsChecker-help.xml',
	'Logo/Office365DnsChecker.svg',
	'Logo/Office365DnsChecker.png',
	'src/Office365DnsChecker.psm1',
	'AUTHORS',
	'CHANGELOG.md',
	'CODE_OF_CONDUCT.md',
	'CONTRIBUTING.md',
	'LICENSE',
	'Office365DnsChecker.code-workspace',
	'Office365DnsChecker.psd1',
	'README.md',
	'SECURITY.md'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

	PSData = @{

		# Tags applied to this module. These help with module discovery in online galleries.
		Tags = @('Microsoft365', 'Office365', '365', 'ExchangeOnline', 'SkypeForBusinessOnline', 'MicrosoftTeams', 'DNS', 'AzureAD', 'AAD', 'SPF', 'DKIM', 'ExO', 'Exchange', 'Teams', 'ExchangeHybrid', '21Vianet', 'DNSSEC', 'DANE', 'MX')

		# A URL to the license for this module.
		LicenseUri = 'https://github.com/rhymeswithmogul/Office365DNSChecker/blob/main/LICENSE'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/rhymeswithmogul/Office365DNSChecker/'

		# A URL to an icon representing this module.
		IconUri = 'https://raw.githubusercontent.com/rhymeswithmogul/Office365DnsChecker/main/Logo/Office365DnsChecker.png'

		# ReleaseNotes of this module
		ReleaseNotes = "- NEW: Add support for Microsoft's new MX records that support DANE and DNSSEC.  Note that this does not go live until March 2024 (as a preview), so there may be bugs that we don't yet know about.
- NEW: `Test-ExchangeOnlineMxRecords`, `Test-ExchangeOnlineRecords`, and `Test-Office365DnsRecords` now support a new `-DANERequired` parameter that prints a warning if the DANE-enabled MX endpoint is *not* in use."

		# Prerelease string of this module
		#Prerelease = 'alpha'

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		RequireLicenseAcceptance = $false

		# External dependent modules of this module
		# ExternalModuleDependencies = @()

	} # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

