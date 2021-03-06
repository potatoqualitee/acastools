﻿function Get-TNScanHostDetail {
    <#
    .SYNOPSIS
        Gets a list of scan host details

    .DESCRIPTION
        Gets a list of scan host details

    .PARAMETER SessionObject
        Optional parameter to force using specific SessionObjects. By default, each command will connect to all connected servers that have been connected to using Connect-TNServer

    .PARAMETER ScanId
        The ID of the target scan

    .PARAMETER HostId
        The ID for the target host

    .PARAMETER HistoryId
        The ID for the target history

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with 'sea of red' exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this 'nice by default' feature off and enables you to catch exceptions with your own try/catch.

    .EXAMPLE
        PS C:\> Get-TNScanHostDetail -ScanId 50 -HostId 10

        Gets a list of scan host details for scan with ID of 50 and Host ID of 10

#>
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [object[]]$SessionObject = (Get-TNSession),
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int32]$ScanId,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int32]$HostId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int32]$HistoryId,
        [switch]$EnableException
    )
    begin {
        $params = @{ }

        if ($HistoryId) {
            $params.Add('history_id', $HistoryId)
        }
    }
    process {
        foreach ($session in $SessionObject) {
            $PSDefaultParameterValues["*:SessionObject"] = $session
            foreach ($detail in (Invoke-TNRequest -SessionObject $session -EnableException:$EnableException -Path "/scans/$ScanId/hosts/$($HostId)" -Method GET -Parameter $params)) {
                [pscustomobject]@{
                    Info            = $detail.info
                    Vulnerabilities = $detail.vulnerabilities
                    Compliance      = $detail.compliance
                    ScanId          = $ScanId
                    SessionId       = $session.SessionId
                }
            }
        }
    }
}