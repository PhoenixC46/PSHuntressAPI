$Path = "D:\Huntress\"
$AuthInfo = [pscustomobject](Get-Content $Path"Huntress.txt" -Raw | ConvertFrom-StringData)
$HKey = $AuthInfo.h1
$HTok = $AuthInfo.h2
$OnError = "SilentlyContinue"
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
    $apiUri = -join($uriBase, $data)
    
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
Function Huntress-GetOrg {
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

Function Huntress-ListSignals {
    param ( 
        [parameter(Mandatory = $false)][Int32]$itemLimit = 10,
        [parameter(Mandatory = $false)][string]$entityType,
        [parameter(Mandatory = $false)][datetime]$dateFrom,
        [parameter(Mandatory = $false)][datetime]$dateTo,
        [parameter(Mandatory = $false)][Int32]$orgId
    )
    $entityType = "agent"
    $itemLimit = 2
    Clear-Variable dataStr -Force -ErrorAction $OnError
    $dataStr = "signals"
    If($itemLimit -ge 1) {
        Write-Host "LimitValue:"$itemLimit
        $dataStr = -join($dataStr, "?limit=" + $itemLimit)}
    If(!$types) {
        Write-Host "TypeValue:"$entityType
        $dataStr = -join($dataStr, "&entity_type=" + $entityType)}
    If($null -ne $dateFrom) {
        try{
            [datetime]::parseexact(($dateFrom.ToString('yyyy-MM-ddThh:mm:ssZ')), 'yyyy-MM-ddThh:mm:ssZ', $null)
            $dataStr = -join($dataStr, '&investigated_at_min=' + ($dateFrom.ToString('yyyy-MM-ddThh:mm:ssZ')) -replace ":","%3A")}
        catch{Write-Host 'Invalid Start Date/Time Format, must be entered as: "yyyy-MM-ddThh:mm:ssZ" (wrapped in "double-quotes")'}
    }
    If($null -ne $dateTo) {
        try{
            [datetime]::parseexact(($dateTo.ToString('yyyy-MM-ddThh:mm:ssZ')), 'yyyy-MM-ddThh:mm:ssZ', $null)
            $dataStr = -join($dataStr, '&investigated_at_max=' + ($dateTo.ToString('yyyy-MM-ddThh:mm:ssZ')) -replace ":","%3A")}
        catch{Write-Host 'Invalid End Date/Time Format, must be entered as: "yyyy-MM-ddThh:mm:ssZ" (wrapped in "double-quotes")'}
    }
    If($orgId -ge 1) {
        Write-Host "orgId:"$orgId
        $dataStr = -join($dataStr, "&organization_id=" + $orgId)}
    $HuntressData = Connect-Huntress -data $dataStr
return $HuntressData.signals}

Function Huntress-GetSignal {
    param ( 
    [parameter(Mandatory = $true)][Int32]$signalId
    )
    $HuntressData = Connect-Huntress -data signals/$signalId
return $HuntressData}

Function Huntress-BillingReports {
    $HuntressData = Connect-Huntress -data billing_reports
return $HuntressData}

Function Huntress-SummaryReports {
    $HuntressData = Connect-Huntress -data reports
return $HuntressData}
