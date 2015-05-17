$Module = "$PSScriptRoot\..\DSCResources\MSFT_xZoneSIte\MSFT_xZoneSite.psm1"
Remove-Module -Name MSFT_xZoneSite -Force -ErrorAction SilentlyContinue
Import-Module -Name $Module -Force -ErrorAction Stop

InModuleScope MSFT_xZoneSite {
    
    Describe 'MSFT_xZoneSite' {
        Context GetZoneSiteName {
            It 'Returns only address-part of URI for http Uri' {
                GetZoneSiteName -Uri 'http://site.domain.top/something/page.html' | Should Be 'site.domain.top'
            }
            It 'Returns only address-part of URI for ftp Uri' {
                GetZoneSiteName -Uri 'ftp://site.domain.top/something/file.ext' | Should Be 'site.domain.top'
            }
            It 'Returns all of an FQDN' {
                GetZoneSiteName -Uri 'server.domain.top' | Should Be 'server.domain.top'
            }
            It 'Returns only server part of UNC path' {
                GetZoneSiteName -Uri '\\server.domain.top\Share\folder\file.ext' | Should Be 'server.domain.top'
                GetZoneSiteName -Uri '\\server\Share\folder\file.ext' | Should Be 'server'
            }
        }
        
        Context Test-TargetResource {
            $Uri  = '\\server.doman.top\share\folder'
            $Type = '*'
            $Zone = 'LocalIntranet'
            
            It 'Returns true if reg entry exists' {
                mock Get-ItemProperty { [pscustomobject]@{$Type = $ZoneList[$Zone]} }
                Test-TargetResource -Uri $Uri -Ensure Present -Type $Type -Zone $Zone -Platform x86 | Should Be $true
            }

            It 'Returns false if reg entry doesn''t exist' {
                mock Get-ItemProperty {}
                Test-TargetResource -Uri $Uri -Ensure Present -Type $Type -Zone $Zone -Platform x86 | Should Be $false
            }
        }
    }
}
