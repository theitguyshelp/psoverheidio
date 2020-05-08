function Get-OpenKVKResult {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$False)]
        [ValidateCount(1,100)]
        [int]$Size = 100,
        [parameter(Mandatory=$False, ParameterSetName="ID")]
        [Alias("OpenKVKID")]
        [string]$ID,
        [parameter(Mandatory=$False, ParameterSetName="Filter")]
        [string]$Postcode,
        [parameter(Mandatory=$False, ParameterSetName="KVKID")]
        [string]$KVKID
    )

    Begin {
        $headers = @{
            'ovio-api-key' = $OverheidIO_APIKey
        }

        $APIEndpoint = "/openkvk"

        $URL = $OverheidIO_APIHost + $APIEndpoint

        if ($ID) {
            $URL = $URL + "/$ID"
        }

        if ($Postcode) {
            $URL = $URL + "?filters[postcode]=$Postcode"
        }

        if ($KVKID) {
            $QueryURL = $URL + "?query=$KVKID&queryfields[]=dossiernummer"
            $QueryResponse = Invoke-RestMethod -Method GET -Uri $QueryURL -Headers $headers
            $URL = $OverheidIO_APIHost + $QueryResponse._embedded.bedrijf._links.self.href
        }
    }

    Process {
        Write-Debug "Making a request to the following URL: $URL"
        $Response = Invoke-RestMethod -Method GET -Uri $URL -Headers $headers
    }

    End {
        return $Response
    }
}