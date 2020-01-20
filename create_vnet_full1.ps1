
$sub = Get-AzSubscription
if (!$sub)
{ 
    Write-Host "cannot detect Azure subscription"
    exit 1 
}
Write-Host $sub

$rg_name = "rg-vnettest3"
$rg_loc = "East US"
$rg = Get-AzResourceGroup -Name $rg_name -ErrorAction SilentlyContinue
if (!$rg)
{
    Write-Host "Azure resource group does not already exist, creating it"
    $rg = New-AzResourceGroup -Name $rg_name -Location $rg_loc
}
else 
{
    Write-Host "Azure resource already exists, deleting and recreating it"
    Remove-AzResourceGroup -Name $rg_name -Force
    $rg = New-AzResourceGroup -Name $rg_name -Location $rg_loc
}
Write-Host $rg

$vnet_name = "vnettest1"
$vnet_address = "10.0.1.0/24"
$vnet = New-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg_name -Location $rg_loc -AddressPrefix $vnet_address
$vnet

$subnet_address = "10.0.1.0/26"
$subnet_name = "subnet1"
Add-AzVirtualNetworkSubnetConfig -Name $subnet_name -VirtualNetwork $vnet -AddressPrefix $subnet_address
$subnet_address = "10.0.1.64/26"
$subnet_name = "subnet2"
Add-AzVirtualNetworkSubnetConfig -Name $subnet_name -VirtualNetwork $vnet -AddressPrefix $subnet_address
Set-AzVirtualNetwork -VirtualNetwork $vnet


