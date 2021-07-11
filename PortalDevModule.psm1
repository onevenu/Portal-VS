
#$global:conn = Get-CrmConnection -InteractiveMode
$global:conn
$global:WebTemplateId
function Portal-Authenticate {
 
    Write-Host "Authenticating.."
    $global:conn = Get-CrmConnection -InteractiveMode
    if($conn){
        Write-Host "Authentication...Success!" -ForegroundColor Green
    }
    else{
        Write-Host "Authentication...Failed!" -ForegroundColor Red
    }
}
function Portal-SearchTemplate {
    param (
       [Parameter(Mandatory=$false)]
       [String]$Name
    )

    if($conn -ne $null ){
     $templateRecords = (Get-CrmRecords -conn $conn -EntityLogicalName adx_webtemplate -Fields adx_name,adx_source -FilterAttribute adx_name -FilterOperator like -FilterValue %$Name%).CrmRecords
        if($templateRecords.Count -gt 0){
            for ($i = 0; $i -lt $templateRecords.Count; $i++) {
                Write-Host [$i] $templateRecords[$i].adx_webtemplateid " | " $templateRecords[$i].adx_name
            }
            Write-Host
            $c = Read-Host "Select Your Template"
            Write-Host
            if($c -lt $i){
                Write-Host "Webtemplate Id is SET in `$WebTemplateId. Use this as ID when needed for "$templateRecords[$c].adx_name 
                $global:WebTemplateId = $templateRecords[$c].adx_webtemplateid
                Write-Host "===========WebTemplate ID============"
                Write-Host $templateRecords[$c].adx_webtemplateid
                Write-Host "====================================="
                Write-Host
            }
            else {
                Write-Host "Invalid Selection" -ForegroundColor Red
            }

        }
    }
    else
    {
        Write-Host "Connection Not Found" -ForegroundColor Red
        Portal-Authenticate
        Write-Host
        Write-Host "Try performing this action again now." -ForegroundColor Yellow
    }
    
}
function Portal-DownloadTemplate {
    param(
    [Parameter(Mandatory=$false)]
    [String]$WebTemplateId = $WebTemplateId,
    [Parameter(Mandatory=$true)]
    [String]$SavePath = "."
    )
    if($conn -ne $null ){
        $webtemplateFromCRM = Get-CrmRecord -conn $conn -EntityLogicalName adx_webtemplate -Id $WebTemplateId -Fields adx_source,adx_name
        $fileName = [string]$webtemplateFromCRM.adx_name+".liquid"
        $fullPath = $SavePath +"\"+$fileName

        if(Test-Path $fullPath){
            $options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
            [int]$defaultchoice = 1

            $opt = $host.UI.PromptForChoice("File Already Exists" , "Do You want to overwrite?" , $Options,$defaultchoice)

            switch($opt) {
                0 { 
                    Write-Host "Overwritten" -ForegroundColor Red
                    $webtemplateFromCRM.adx_source | Out-File $fullPath
                }
                1 { 
                    Write-Host "OK" -ForegroundColor Green
                    return
                }
            }
        }
        else {
            $webtemplateFromCRM.adx_source | Out-File $fullPath
        }
    }
    else
    {
        Write-Host "Connection Not Found" -ForegroundColor Red
        Portal-Authenticate
        Write-Host
        Write-Host "Try performing this action again now." -ForegroundColor Yellow
    }
   
}
function Portal-UploadTemplate {
    param(
    [Parameter(Mandatory=$true)]
    [String]$WebTemplateId,
    [Parameter(Mandatory=$true)]
    [String]$FilePath
    )

    if($conn -ne $null ){
        if(Test-path $FilePath){
            $file_data = Get-Content $FilePath -Raw
            Set-CrmRecord -conn $conn -EntityLogicalName adx_webtemplate -Fields @{"adx_source"=$file_data} -Id $WebTemplateId -Verbose
            Write-Host "Web Template Uploaded Successfully.." -ForegroundColor Green
        }
        else{
            Write-Host "File Not Found" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Connection Not Found" -ForegroundColor Red
        Portal-Authenticate
        Write-Host
        Write-Host "Try performing this action again now." -ForegroundColor Yellow
    }
}

Export-ModuleMember -Function Portal-SearchTemplate
Export-ModuleMember -Function Portal-DownloadTemplate
Export-ModuleMember -Function Portal-UploadTemplate
Export-ModuleMember -Function Portal-Authenticate
