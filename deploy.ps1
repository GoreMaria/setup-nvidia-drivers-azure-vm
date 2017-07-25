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
Set-AzureStorageBlobContent -Container $storageContainerName -File ".\assets\369.95_win8_win7_64bit_international-1019205-02.zip" -Context $storageAccount.Context -Force 
Set-AzureStorageBlobContent -Container $storageContainerName -File ".\assets\nvidia.cer" -Context $storageAccount.Context -Force
Set-AzureStorageBlobContent -Container $storageContainerName -File ".\assets\setup-server.ps1" -Context $storageAccount.Context -Force

# Generate the value for artifacts location SAS token
$artifactsLocationSasToken = New-AzureStorageContainerSASToken -Container $storageContainerName -Context $storageAccount.Context -Permission lr -ExpiryTime (Get-Date).AddHours(1)
$artifactsLocationSasToken = ConvertTo-SecureString $artifactsLocationSasToken -AsPlainText -Force

$artifactsLocation = $storageAccount.PrimaryEndpoints.Blob + $StorageContainerName

$deployName = 'deploy-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')


# $DebugPreference = Continue

<#
Test-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile '.\azuredeploy.json' `
    -TemplateParameterFile '.\azuredeploy.parameters.json' `
    -_artifactsLocation $artifactsLocation `
    -_artifactsLocationSasToken $artifactsLocationSasToken `
    -Verbose
#>


New-AzureRmResourceGroupDeployment -Name $deployName `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile '.\azuredeploy.json' `
    -TemplateParameterFile '.\azuredeploy.parameters.json' `
    -_artifactsLocation $ArtifactsLocation `
    -_artifactsLocationSasToken $ArtifactsLocationSasToken `
    -Verbose `
    -DeploymentDebugLogLevel All

