function Get-OpenKVKSuggestion {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$False)]
        [ValidateCount(1,25)]
        [int]$Size = 10,
        [parameter(Mandatory=$False)]
        [String]$Query
    )

    Begin {
        $headers = @{
            'ovio-api-key' = $OverheidIO_APIKey
        }

        $APIEndpoint = "/suggest/openkvk/"

        $URL = $OverheidIO_APIHost + $APIEndpoint + $Query + "?size=$Size" + "&fields[]=handelsnaam" + "&fields[]=dossiernummer"

    }

    Process {
        Write-Debug "Making a request to the following URL: $URL"
        $Response = Invoke-RestMethod -Method GET -Uri $URL -Headers $headers
    }

    End {
        return $Response
    }
}