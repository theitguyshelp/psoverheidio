function Add-OverheidIOCredentials {
    [cmdletbinding()]
    
    param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$APIkey
    )

    Begin {
    }

    Process {
    }

    End {
        Set-Variable -Name "OverheidIO_APIHost" -Value "https://api.overheid.io" -Scope Global -Option ReadOnly -Force
        Set-Variable -Name "OverheidIO_APIKey" -Value $APIkey -Scope Global -Option ReadOnly -Force
    }
}