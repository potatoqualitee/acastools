﻿Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
. "$PSScriptRoot\..\constants.ps1"


Describe "Integration Tests" -Tag "IntegrationTests" {
    BeforeAll {
        # Ensure Nessus is warmed up
        Wait-TNServerReady -ComputerName localhost

        # Set universal parameter values
        $PSBoundParameters['*:WarningAction'] = "SilentlyContinue"
        $PSBoundParameters['*:WarningVariable'] = "warning"

        # Connect then add policy to test later
        $cred = New-Object -TypeName PSCredential -ArgumentList "admin", (ConvertTo-SecureString -String admin123 -AsPlainText -Force)
        $splat = @{
            ComputerName         = "localhost"
            AcceptSelfSignedCert = $false
            Credential           = $cred
            EnableException      = $true
            Port                 = 8834
        }
        $null = Connect-TNServer @splat
        # add policy
        $params = @{
            Path        = "/policies"
            Method      = "POST"
            ContentType = "application/json"
            Parameter   = '{"uuid":"bbd4f805-3966-d464-b2d1-0079eb89d69708c3a05ec2812bcf","settings":{"display_unreachable_hosts":"no","log_live_hosts":"yes","reverse_lookup":"no","allow_post_scan_editing":"yes","udp_scanner":"no","syn_scanner":"yes","syn_firewall_detection":"Automatic (normal)","tcp_scanner":"no","tcp_firewall_detection":"Automatic (normal)","portscan_range":"default","unscanned_closed":"no","wol_wait_time":"5","wol_mac_addresses":"","scan_netware_hosts":"no","scan_network_printers":"no","ping_the_remote_host":"yes","udp_ping":"no","icmp_ping":"yes","icmp_ping_retries":"2","icmp_unreach_means_host_down":"no","tcp_ping":"yes","tcp_ping_dest_ports":"built-in","arp_ping":"yes","fast_network_discovery":"no","test_local_nessus_host":"yes","discovery_mode":"Host enumeration","acls":[{"object_type":"policy","permissions":0,"type":"default"}],"description":"","name":"Test Policy"}}'
        }
        $null = Invoke-TNRequest @params
        # add scan
        $params = @{
            Path        = "/scans"
            Method      = "POST"
            ContentType = "application/json"
            Parameter   = '{"uuid":"731a8e52-3ea6-a291-ec0a-d2ff0619c19d7bd788d6be818b65","credentials":{"add":{},"edit":{},"delete":[]},"settings":{"patch_audit_over_rexec":"no","patch_audit_over_rsh":"no","patch_audit_over_telnet":"no","additional_snmp_port3":"161","additional_snmp_port2":"161","additional_snmp_port1":"161","snmp_port":"161","http_login_auth_regex_nocase":"no","http_login_auth_regex_on_headers":"no","http_login_invert_auth_regex":"no","http_login_max_redir":"0","http_reauth_delay":"","http_login_method":"POST","enable_admin_shares":"no","start_remote_registry":"no","dont_use_ntlmv1":"yes","never_send_win_creds_in_the_clear":"yes","attempt_least_privilege":"no","ssh_client_banner":"OpenSSH_5.0","ssh_port":"22","ssh_known_hosts":"","enable_plugin_debugging":"no","log_whole_attack":"no","max_simult_tcp_sessions_per_scan":"","max_simult_tcp_sessions_per_host":"","max_hosts_per_scan":"30","max_checks_per_host":"5","network_receive_timeout":"5","reduce_connections_on_congestion":"no","slice_network_addresses":"no","stop_scan_on_disconnect":"no","safe_checks":"yes","advanced_mode":"Default","display_unreachable_hosts":"no","log_live_hosts":"no","reverse_lookup":"no","allow_post_scan_editing":"yes","silent_dependencies":"yes","report_superseded_patches":"yes","report_verbosity":"Normal","enum_local_users_end_uid":"1200","enum_local_users_start_uid":"1000","enum_domain_users_end_uid":"1200","enum_domain_users_start_uid":"1000","request_windows_domain_info":"yes","scan_webapps":"no","test_default_oracle_accounts":"no","provided_creds_only":"yes","thorough_tests":"no","report_paranoia":"Normal","assessment_mode":"default","detect_ssl":"yes","check_crl":"no","enumerate_all_ciphers":"yes","cert_expiry_warning_days":"60","ssl_prob_ports":"Known SSL ports","svc_detection_on_all_ports":"yes","udp_scanner":"no","syn_scanner":"yes","syn_firewall_detection":"Automatic (normal)","tcp_scanner":"no","tcp_firewall_detection":"Automatic (normal)","verify_open_ports":"no","only_portscan_if_enum_failed":"yes","snmp_scanner":"yes","wmi_netstat_scanner":"yes","ssh_netstat_scanner":"yes","portscan_range":"default","unscanned_closed":"no","wol_wait_time":"5","wol_mac_addresses":"","scan_netware_hosts":"no","scan_network_printers":"no","ping_the_remote_host":"yes","udp_ping":"no","icmp_ping":"yes","icmp_ping_retries":"2","icmp_unreach_means_host_down":"no","tcp_ping":"yes","tcp_ping_dest_ports":"built-in","arp_ping":"yes","fast_network_discovery":"no","test_local_nessus_host":"yes","discovery_mode":"Port scan (common ports)","emails":"","filter_type":"and","filters":[],"launch_now":false,"enabled":false,"file_targets":"","text_targets":"0.0.0.0/8","scanner_id":"1","folder_id":3,"description":"","name":"Test Scan"}}'
        }
        $null = Invoke-TNRequest @params
    }
    BeforeEach {
        Write-Output -Message "Next test"
    }
    Context "Connect-TNServer" {
        It "Connects to a site" {
            $cred = New-Object -TypeName PSCredential -ArgumentList "admin", (ConvertTo-SecureString -String admin123 -AsPlainText -Force)
            $splat = @{
                ComputerName         = "localhost"
                AcceptSelfSignedCert = $false
                Credential           = $cred
                EnableException      = $true
                Port                 = 8834
            }
            (Connect-TNServer @splat).ComputerName | Should -Be "localhost"
            # Nessus has restricted some API access in higher versions
            $script:version = (Get-TNSession).ServerVersionMajor
        }
    }
    Context "Get-TNUser" {
        It "Returns a user..or doesnt" {
            if ($script:version -ge 8) {
                Get-TNUser 3>$null | Select-Object -ExpandProperty name | Should -BeNullOrEmpty
            } else {
                Get-TNUser | Select-Object -ExpandProperty name | Should -Contain "admin"
            }
        }
    }

    Context "Get-TNFolder" {
        It "Returns a folder" {
            Get-TNFolder | Select-Object -ExpandProperty name | Should -Contain "Trash"
        }
    }

    Context "Get-TNGroup" {
        It "Doesn't return a group but does return a warning" {
            Get-TNGroup -WarningVariable warning 3>$null
            $warning | Should -match "not licenced for multiple users"
        }
    }

    Context "Get-TNGroupMember" {
        It "Doesn't return a group member but does return a warning" {
            Get-TNGroupMember -GroupId 0 -WarningVariable warning 3>$null
            $warning | Should -match "not licenced for multiple users"
        }
    }

    Context "Get-TNPlugin" {
        It "Returns proper plugin information" {
            $results = Get-TNPlugin -PluginId 100000
            $results.Name | Should -Be 'Test Plugin for tentools'
            $results.PluginId | Should -Be 100000
            ($results.Attributes).fname | Should -Be 'tentools_test.nasl'
        }
    }

    Context "Get-TNPluginFamily" {
        It "Returns proper plugin family information" {
            $results = Get-TNPluginFamily -FamilyId 1
            $results.Name | Should -Be 'Misc.'
        }
    }

    Context "Add-TNPluginRule" {
        It "Adds a plugin rule" {
            $results = Add-TNPluginRule -PluginId 100000 -Type High -ComputerName localhost
            $results.PluginId | Should -Be 100000
        }
    }

    Context "Get-TNPluginRule" {
        It "Returns proper plugin rule information" {
            $results = Get-TNPluginRule
            $results.Type | Should -Contain 'High'
        }
    }
    Context "Get-TNPolicy" {
        It "Returns proper policy information" {
            $results = Get-TNPolicy
            $results.Name | Should -Be 'Test Policy'
        }
    }
    Context "Get-TNPolicyDetail" {
        It "Returns proper policy detail information" {
            $results = Get-TNPolicy | Select-Object Id | Get-TNPolicyDetail
            $results.Title | Should -Contain 'Host Discovery'
        }
    }

    Context "Get-TNPolicyLocalPortEnumeration" {
        It "Returns proper policy detail information for piped results" {
            $results = Get-TNPolicy | Select-Object Id | Get-TNPolicyDetail | Get-TNPolicyLocalPortEnumeration
            $results.PolicyId | Should -Contain 4
        }
        It "Returns proper policy detail information from parameter" {
            $results = Get-TNPolicyLocalPortEnumeration -PolicyId 4
            $results.PolicyId | Should -Be 4
        }
    }

    Context "Get-TNPolicyPortRange" {
        It "Returns proper policy range information for piped results" {
            $results = Get-TNPolicy | Select-Object Id | Get-TNPolicyDetail | Get-TNPolicyPortRange
            $results.PolicyId | Should -Contain 4
        }
        It "Returns proper policy range information from parameter" {
            $results = Get-TNPolicyPortRange -PolicyId 4
            $results.PolicyId | Should -Be 4
        }
    }

    Context "Get-TNPolicyTemplate" {
        It "Returns proper policy template information for piped results" {
            $results = Get-TNPolicy | Select-Object Id | Get-TNPolicyDetail | Get-TNPolicyTemplate
            $results.Name | Should -Contain 'discovery'
        }
        It "Returns proper policy template information from parameter" {
            $results = Get-TNPolicyTemplate
            $results.Title | Should -Contain 'Spectre and Meltdown'
        }
    }

    # Gotta skip v8 on Actions
    write-warning (Get-TNSession).ServerVersionMajor
    Context "Get-TNScan" {
        if ((Get-TNSession).ServerVersionMajor -ne 8) {
            It "Returns proper scan information" {
                $results = Get-TNScan
                $results.Name | Should -Contain 'Test Scan'
            }
        }
    }
}