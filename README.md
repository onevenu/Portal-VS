# PowerApps Portal Web Template Developement Cheatsheet
    This script/functions can reduce a lot of development effort by quicky uploading the changed liquid code to Dynamics CRM online. VSCODE contains extensions to support liquid template files along with autocompletion for javascripts and color coding schemes. All these really help in developement when the code size increases.


## Follow these to setup VSCODE

1. Install VSCODE
2. Install these extension - **Shopify Liquid Template Snippets** & **Liquid Languages Support** & **PowerShell**
3. Add this in Settings.json of VSCODE  **"emmet.includeLanguages": { "liquid": "html" }**

**NOTE:** 

    1. Editor extensions works best on .liquid extension.
    2. Change Powershell Session to Windows Powershell as Powershell Core is not supported
        - Ctrl + Shift + P On VSCODE to open command pallet
        - Type Session and select PowerShell: Show Session Menu
        - Then Switch To: Windows PowerShell(x64)

## Install XRM Connector in PowerShell
Execute following commands in Admin Mode in Windows PowerShell.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module -Name Microsoft.Xrm.Data.PowerShell
```
## How To Use
Use VSCODE terminal and change session to Windows Powershell as above in NOTE.

```powershell
#Ignore the warnings
Import-Module .\PortalDevModule.psm1 

#Authenticate. This is per session.
Portal-Authenticate

#Find Webtemplates
Portal-SearchTemplate -Name Facet
#NOTE: Your selected webtemplateid is saved in $WebTemplateId. You can use this variable in other functions to input ID.

#Download Webtemplate to your local.
Portal-DownloadTemplate -WebTemplateId $WebTemplateId -SavePath .

#Push your changes to CRM.
Portal-UploadTemplate -WebTemplateId $WebTemplateId -FilePath '.\Faceted Search - Paging Template.liquid'

# NOTE: Up Arrow to quick select and execute this.😎
```