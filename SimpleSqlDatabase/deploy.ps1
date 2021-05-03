# create a Resource Group
New-AzResourceGroup -Name 'BicepTest' -Location 'northeurope'

# Validate the deployment with Whatif
$DeploymentConfig = @{
    ResourceGroupName = 'BicepTest' 
    TemplateFile      = '.\SimpleSqlDatabase\SqlInstance.bicep' 
    WhatIf            = $true
}
New-AzResourceGroupDeployment @DeploymentConfig

# Deploy the changes
$DeploymentConfig = @{
    ResourceGroupName = 'BicepTest' 
    TemplateFile      = '.\SimpleSqlDatabase\SqlInstance.bicep' 
    WhatIf            = $false
}
New-AzResourceGroupDeployment @DeploymentConfig

# Remove the resource group

Remove-AzResourceGroup -Name BicepTest -Force
