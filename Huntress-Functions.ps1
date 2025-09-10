$Path = "D:\SecureTokenFolder\"
$AuthInfo = [pscustomobject](Get-Content $Path"Huntress.txt" -Raw | ConvertFrom-StringData)
$HKey = $AuthInfo.h1
$HTok = $AuthInfo.h2
Function Connect-Huntress {
    param ( 
    [parameter(Mandatory = $true)][string]$data
    )
    $apiKey = $HKey
    $apiSecret = $HTok
    $apiAuth = "$apiKey`:$apiSecret"
    $apiAuthEnc = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiAuth))
    $headers = @{"Authorization" = "Basic $apiAuthEnc"}
    $uriBase = 'https://api.huntress.io/v1/'
    $uri = $uriBase + $data
    $apiUri = $uri

    try {
        $response = Invoke-RestMethod -Uri $apiUri -Headers $headers -Method Get
        Write-Host "Successfully authenticated and received payload:"
        $response | ConvertTo-Json -Depth 5
    }
    catch {
        Write-Host "Error authenticating or calling the Huntress API:"
        Write-Host $_.Exception.Message
        $response = $_.Exception.Message
    }
return $response
}

Function Huntress-ListAccounts {
    $HuntressData = Connect-Huntress -data account
return $HuntressData}

Function Huntress-ListOrgs {
    $HuntressData = Connect-Huntress -data organizations
return $HuntressData}
Function Huntress-GetAgent {
    param ( 
    [parameter(Mandatory = $true)][Int32]$orgId
    )
    $HuntressData = Connect-Huntress -data organizations/$orgId
return $HuntressData}

Function Huntress-ListAgents {
    $HuntressData = Connect-Huntress -data agents
return $HuntressData}
Function Huntress-GetAgent {
    param ( 
    [parameter(Mandatory = $true)][Int32]$agentId
    )
    $HuntressData = Connect-Huntress -data agents/$agentId
return $HuntressData}

Function Huntress-Signals {
    $HuntressData = Connect-Huntress -data signals
return $HuntressData}

Function Huntress-BillingReports {
    $HuntressData = Connect-Huntress -data billing_reports
return $HuntressData}

Function Huntress-SummaryReports {
    $HuntressData = Connect-Huntress -data reports
return $HuntressData}
