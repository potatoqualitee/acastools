function Remove-TNScanZone {
    <#
    .SYNOPSIS
        Removes a list of scan zones

    .DESCRIPTION
        Removes a list of scan zones

    .PARAMETER SessionObject
        Optional parameter to force using specific SessionObjects. By default, each command will connect to all connected servers that have been connected to using Connect-TNServer

    .PARAMETER Name
        The ID of the target scan zone

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with 'sea of red' exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this 'nice by default' feature off and enables you to catch exceptions with your own try/catch.

    .EXAMPLE
        PS C:\> Remove-TNScanZone

        Removes a list of scan zones

#>
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [object[]]$SessionObject = (Get-TNSession),
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Name,
        [switch]$EnableException
    )
    process {
        foreach ($session in $SessionObject) {
            $PSDefaultParameterValues["*:SessionObject"] = $session
            foreach ($scanzonename in $Name) {
                $id = (Get-TNScanZone | Where-Object Name -eq $scanzonename).Id
                if ($id) {
                    Write-PSFMessage -Level Verbose -Message "Deleting scan zone with id $id"
                    Invoke-TNRequest -SessionObject $session -EnableException:$EnableException -Path "/zone/$id" -Method Delete | ConvertFrom-TNRestResponse
                }
            }
        }
    }
}