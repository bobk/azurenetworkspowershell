
$sub = Get-AzSubscription
if (!$sub)
{ 
    Write-Host "cannot detect Azure subscription"
    exit 1 
}
Write-Host $sub

$rg_name = "rg-vnettest"
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

$vnet_name = "vnettest-vnet"
$vnet_address = "10.0.1.0/24"
$vnet = New-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg_name -Location $rg_loc -AddressPrefix $vnet_address
$vnet

$subnet1_address = "10.0.1.0/26"
$subnet1_name = "subnet1"
$subnet1 = Add-AzVirtualNetworkSubnetConfig -Name $subnet1_name -VirtualNetwork $vnet -AddressPrefix $subnet1_address
$subnet2_address = "10.0.1.64/26"
$subnet2_name = "subnet2"
$subnet2 = Add-AzVirtualNetworkSubnetConfig -Name $subnet2_name -VirtualNetwork $vnet -AddressPrefix $subnet2_address
Set-AzVirtualNetwork -VirtualNetwork $vnet

$nic1_name = "vnettestnic1"
$nic1_ipconfig_name = "ipconfig1"
$nic1 = New-AzNetworkInterface -Name $nic1_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet_name + "/subnets/" + $subnet1_name) -IpConfigurationName $nic1_ipconfig_name
$nic1.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic1.IpConfigurations[0].PrivateIpAddress = "10.0.1.4"
Set-AzNetworkInterface -NetworkInterface $nic1
$nic2_name = "vnettestnic2"
$nic2_ipconfig_name = "ipconfig2"
$nic2 = New-AzNetworkInterface -Name $nic2_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet_name + "/subnets/" + $subnet2_name) -IpConfigurationName $nic2_ipconfig_name
$nic2.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic2.IpConfigurations[0].PrivateIpAddress = "10.0.1.68"
Set-AzNetworkInterface -NetworkInterface $nic2

