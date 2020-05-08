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
        $ReturnObject = @()
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
    }

    Process {
        if ($KVKID) {
            $QueryURL = $URL + "?query=$KVKID&queryfields[]=dossiernummer"
            $QueryResponses = Invoke-RestMethod -Method GET -Uri $QueryURL -Headers $headers
            Write-Debug "Overheid.io returned $($QueryResponses.count) links"
            Foreach ($QueryResponse in $QueryResponses._embedded.bedrijf) {
                $URL = $OverheidIO_APIHost + $QueryResponse._links.self.href
                $Response = Invoke-RestMethod -Method GET -Uri $URL -Headers $headers
                Write-Debug "Making a request to the following URL: $URL"
                $ReturnObject += $Response
            }
            
        }
        else {
            $Response = Invoke-RestMethod -Method GET -Uri $URL -Headers $headers
            Write-Debug "Making a request to the following URL: $URL"
            $ReturnObject += $Response
        }
    }

    End {
        return $ReturnObject
    }
}