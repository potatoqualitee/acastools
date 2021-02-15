﻿#
# Module manifest for module 'tentools'
#
@{

    # Script module or binary module file associated with this manifest.
    RootModule         = 'tentools.psm1'

    # Version number of this module.
    ModuleVersion      = '0.0.1'

    # ID used to uniquely identify this module
    GUID               = '1e19a8e4-ef98-4f0a-bd7d-f6613c3b7375'

    # Author of this module
    Author             = 'Chrissy LeMaire'

    # Copyright statement for this module
    Copyright          = 'Copyright (c) 2021, licensed under BSD 3'

    # Description of the functionality provided by this module
    Description        = "Automation for DISA ACAS, including tenable.sc, Nessus and more. Based off of Carlos Perez's Posh-Nessus module and commands by Joseph Warren."

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules    = @('PSFramework', 'PoshRSJob')

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @('bin\RestSharp.dll')

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess   = @()

    # Functions to export from this module
    FunctionsToExport  = @(
        'Add-TNGroupUser',
        'Add-TNPluginRule',
        'Add-TNPolicyPortRange',
        'Connect-TNServer',
        'ConvertFrom-TNRestResponse',
        'Copy-TNPolicy',
        'Disable-TNPolicyLocalPortEnumeration',
        'Disable-TNPolicyPortScanner',
        'Edit-TNPluginRule',
        'Enable-TNPolicyLocalPortEnumeration',
        'Enable-TNPolicyPortScanner',
        'Export-TNPolicy',
        'Export-TNScan',
        'Get-TNAsset',
        'Get-TNAudit',
        'Get-TNCredential',
        'Get-TNDashboard',
        'Get-TNFolder',
        'Get-TNGroup',
        'Get-TNOrganization',
        'Get-TNPluginFamily',
        'Get-TNPluginRule',
        'Get-TNPolicy',
        'Get-TNPolicyDetail',
        'Get-TNPolicyLocalPortEnumeration',
        'Get-TNPolicyPortRange',
        'Get-TNPolicyPortScanner',
        'Get-TNPolicyTemplate',
        'Get-TNRole',
        'Get-TNScan',
        'Get-TNScanner',
        'Get-TNScanResult',
        'Get-TNScanTemplate',
        'Get-TNScanZone',
        'Get-TNServerInfo',
        'Get-TNServerStatus',
        'Get-TNSession',
        'Get-TNSessionInfo',
        'Get-TNUser',
        'Get-TNLdapServer',
        'Get-TNReport',
        'Get-TNReportResult',
        'Get-TNReportAttribute',
        'Get-TNRepository',
        'Get-TNOrganizationUser',
        'Import-TNAsset',
        'Import-TNAudit',
        'Import-TNCustomPlugin',
        'Import-TNDashboard',
        'Import-TNPolicy',
        'Import-TNReport',
        'Import-TNScan',
        'Initialize-TNServer',
        'Invoke-TNRequest',
        'New-TNAsset',
        'New-TNCredential',
        'New-TNFolder',
        'New-TNGroup',
        'New-TNLdapServer',
        'New-TNPolicy',
        'New-TNRepository',
        'New-TNOrganization',
        'New-TNOrganizationUser',
        'New-TNReportAttribute',
        'New-TNScanZone',
        'New-TNScan',
        'New-TNUser',
        'Remove-TNAudit',
        'Remove-TNAsset',
        'Remove-TNCredential',
        'Remove-TNDashboard',
        'Remove-TNGroup',
        'Remove-TNGroupUser',
        'Remove-TNPluginRule',
        'Remove-TNPolicy',
        'Remove-TNReport',
        'Remove-TNReportResult',
        'Remove-TNScan',
        'Remove-TNScanner',
        'Remove-TNScanZone',
        'Remove-TNScanHistory',
        'Remove-TNSession',
        'Remove-TNUser',
        'Remove-TNOrganization'
        'Remove-TNOrganizationUser',
        'Remove-TNRepository',
        'Rename-TNGroup',
        'Resume-TNScan',
        'Restart-TNService',
        'Save-TNPlugin',
        'Save-TNScapFile',
        'Save-TNAudit',
        'Save-TNScanResult',
        'Save-TNReportResult',
        'Set-TNPolicyPortRange',
        'Set-TNRepositoryProperty',
        'Set-TNUserPassword',
        'Start-TNDeploy',
        'Start-TNReport',
        'Get-TNGroupMember',
        'Get-TNPlugin',
        'Get-TNPluginFamilyDetails',
        'Get-TNScanDetail',
        'Get-TNScanHistory',
        'Get-TNScanHost',
        'Get-TNScanHostDetail',
        'Set-TNCertificate',
        'Set-TNScanZoneProperty',
        'Start-TNDeploy',
        'Start-TNScan',
        'Stop-TNScan',
        'Suspend-TNScan',
        'Test-TNAccessibility',
        'Wait-TNServerReady'
        'Add-TNScanner',
        'Remove-TNFolder',
        'Rename-TNFolder',
        'Set-TNScanProperty',
        'New-TNDisaAsrReport',
        'Get-TNSystemLog',
        'Get-TNQuery',
        'New-TNQuery',
        'Remove-TNQuery'
    )

    # Cmdlets to export from this module
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module
    AliasesToExport    = @()

    PrivateData        = @{
        # PSData is module packaging and gallery metadata embedded in PrivateData
        # It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
        # We had to do this because it's the only place we're allowed to extend the manifest
        # https://connect.microsoft.com/PowerShell/feedback/details/421837
        PSData = @{
            # The primary categorization of this module (from the TechNet Gallery tech tree).
            Category     = "Security"

            # Keyword tags to help users find this module via navigations and search.
            Tags         = @('nessus', 'tenable', 'acas', 'security', 'disa', 'dod', 'tenable.sc', 'securitycenter', 'Assured Compliance Assessment Solution')

            # The web address of an icon which can be used in galleries to represent this module
            IconUri      = "https://user-images.githubusercontent.com/8278033/107939993-d9c88f80-6f87-11eb-892b-a7f090b1f619.png"

            # The web address of this module's project or support homepage.
            ProjectUri   = "https://github.com/potatoqualitee/tentools"

            # The web address of this module's license. Points to a page that's embeddable and linkable.
            LicenseUri   = "https://opensource.org/licenses/MIT"

            # Release notes for this particular version of the module
            ReleaseNotes = ""

            # If true, the LicenseUrl points to an end-user license (not just a source license) which requires the user agreement before use.
            # RequireLicenseAcceptance = ""

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'True'
        }
    }
}

