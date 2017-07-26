$subscriptionId = "[YOUR-SUBSCRIPTION-ID-HERE]"
$resourceGroupName = "[YOUR-RESOURCE-GROUP-NAME-HERE]"
$storageAccountName = "[YOUR-STORAGE-ACCOUNT-NAME-HERE]"
$storageContainerName = "assets"
$location = "northcentralus"


Login-AzureRmAccount -subscriptionId $SubscriptionId


# Create a new resource group
New-AzureRmResourceGroup -Name $resourceGroupName `
    -Location $location `
    -Tag @{alias = "mcollier"; deleteAfter = "08/30/2017"} `
    -Force

# Create a new storage account
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind Storage `


# Get the storage account for the artifacts to be deployed.
$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName


# Create the container
New-AzureStorageContainer -Name $storageContainerName -Context $storageAccount.Context

# Upload the assets to storage
# NOTE: Uploading a ~280MB blob can take several minutes (depending on upload speeds).
Set-AzureStorageBlobContent -Container $storageContainerName -File ".\assets\370.12_grid_win8_win7_server2012R2_server2008R2_64bit_international.exe" -Context $storageAccount.Context -Force 
Set-AzureStorageBlobContent -Container $storageContainerName -File ".\assets\setup-server.ps1" -Context $storageAccount.Context -Force


$deployName = 'deploy-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')


<#
Test-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile '.\azuredeploy.json' `
    -TemplateParameterFile '.\azuredeploy.parameters.json' `
    -scriptStorageAccountName $storageAccountName `
    -scriptStorageAccountKey $storageAccountKey `
    -Verbose
#>


New-AzureRmResourceGroupDeployment -Name $deployName `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile '.\azuredeploy.json' `
    -TemplateParameterFile '.\azuredeploy.parameters.json' `
    -assetStorageAccountName $storageAccountName `
    -Verbose 
    
