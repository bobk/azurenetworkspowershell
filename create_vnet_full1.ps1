
# http://github.com/bobk/azurenetworkspowershell
#
# This example code set demonstrates code written in PowerShell that creates and modifies a full set of Azure networking objects from scratch
#    - the code uses PowerShell 5.1 and the Az.Network 2.2.x PowerShell modules.
#    - written to better understand Chapter 4 of the Microsoft Azure Administrator AZ-103 exam reference (Microsoft Press)
#
# this is a demo of Azure network code and is not intended to be an exhaustive sample of error checking every operation
#

#   first make sure we are are connected and have a valid subscription
$sub = Get-AzSubscription
if (!$sub)
{ 
    Write-Host "cannot detect Azure subscription"
    exit 1 
}
Write-Host ("subscription ID: " + $sub.ID.ToString())

#   next, make sure our resource group is present and clean, delete and recreate it if needed
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
    Write-Host "Azure resource group already exists, deleting and recreating it"
    Remove-AzResourceGroup -Name $rg_name -Force
    $rg = New-AzResourceGroup -Name $rg_name -Location $rg_loc 
}
Write-Host ($rg_name + " now ready")

#   create first vnet
$vnet1_name = "vnettest-vnet1"
$vnet1_address = "10.0.1.0/24"
$vnet1 = New-AzVirtualNetwork -Name $vnet1_name -ResourceGroupName $rg_name -Location $rg_loc -AddressPrefix $vnet1_address

#   create subnets in vnet
$subnet11_address = "10.0.1.0/26"
$subnet11_name = "subnet11"
$subnet11 = Add-AzVirtualNetworkSubnetConfig -Name $subnet11_name -VirtualNetwork $vnet1 -AddressPrefix $subnet11_address -WarningAction SilentlyContinue
$subnet12_address = "10.0.1.64/26"
$subnet12_name = "subnet12"
$subnet12 = Add-AzVirtualNetworkSubnetConfig -Name $subnet12_name -VirtualNetwork $vnet1 -AddressPrefix $subnet12_address  -WarningAction SilentlyContinue
#   submit the changes, then refresh the vnet object
Set-AzVirtualNetwork -VirtualNetwork $vnet1
$vnet1 = Get-AzVirtualNetwork -ResourceGroupName $rg_name -Name $vnet1_name

#   create NIC(s) with static IP(s) on subnet(s)
$nic11_name = "vnettest-nic11"
$nic11_ipconfig_name = "ipconfig11"
$nic11 = New-AzNetworkInterface -Name $nic11_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet1_name + "/subnets/" + $subnet11_name) -IpConfigurationName $nic11_ipconfig_name
$nic11.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic11.IpConfigurations[0].PrivateIpAddress = "10.0.1.4"
Set-AzNetworkInterface -NetworkInterface $nic11
$nic12_name = "vnettest-nic12"
$nic12_ipconfig_name = "ipconfig12"
$nic12 = New-AzNetworkInterface -Name $nic12_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet1_name + "/subnets/" + $subnet12_name) -IpConfigurationName $nic12_ipconfig_name
$nic12.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic12.IpConfigurations[0].PrivateIpAddress = "10.0.1.68"
Set-AzNetworkInterface -NetworkInterface $nic12

#   create first vnet
$vnet2_name = "vnettest-vnet2"
$vnet2_address = "10.0.2.0/24"
$vnet2 = New-AzVirtualNetwork -Name $vnet2_name -ResourceGroupName $rg_name -Location $rg_loc -AddressPrefix $vnet2_address

#   create subnets in vnet
$subnet21_address = "10.0.2.0/26"
$subnet21_name = "subnet21"
$subnet21 = Add-AzVirtualNetworkSubnetConfig -Name $subnet21_name -VirtualNetwork $vnet2 -AddressPrefix $subnet21_address -WarningAction SilentlyContinue
#   submit the changes, then refresh the vnet object
Set-AzVirtualNetwork -VirtualNetwork $vnet2
$vnet2 = Get-AzVirtualNetwork -ResourceGroupName $rg_name -Name $vnet2_name

#   create NIC(s) with static IP(s) on subnet(s)
$nic21_name = "vnettest-nic21"
$nic21_ipconfig_name = "ipconfig21"
$nic21 = New-AzNetworkInterface -Name $nic21_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet2_name + "/subnets/" + $subnet21_name) -IpConfigurationName $nic21_ipconfig_name
$nic21.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic21.IpConfigurations[0].PrivateIpAddress = "10.0.2.4"
Set-AzNetworkInterface -NetworkInterface $nic21

#   create first vnet
$vnet3_name = "vnettest-vnet3"
$vnet3_address = "10.0.3.0/24"
$vnet3 = New-AzVirtualNetwork -Name $vnet3_name -ResourceGroupName $rg_name -Location $rg_loc -AddressPrefix $vnet3_address

#   create subnets in vnet
$subnet31_address = "10.0.3.0/26"
$subnet31_name = "subnet31"
$subnet31 = Add-AzVirtualNetworkSubnetConfig -Name $subnet31_name -VirtualNetwork $vnet3 -AddressPrefix $subnet31_address -WarningAction SilentlyContinue
#   submit the changes, then refresh the vnet object
Set-AzVirtualNetwork -VirtualNetwork $vnet3
$vnet3 = Get-AzVirtualNetwork -ResourceGroupName $rg_name -Name $vnet3_name

#   create NIC(s) with static IP(s) on subnet(s)
$nic31_name = "vnettest-nic31"
$nic31_ipconfig_name = "ipconfig31"
$nic31 = New-AzNetworkInterface -Name $nic31_name -ResourceGroupName $rg_name -Location $rg_loc -SubnetId ("/subscriptions/" + $sub.ToString() + "/resourceGroups/" + $rg_name + "/providers/Microsoft.Network/virtualNetworks/" + $vnet3_name + "/subnets/" + $subnet31_name) -IpConfigurationName $nic31_ipconfig_name
$nic31.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic31.IpConfigurations[0].PrivateIpAddress = "10.0.3.4"
Set-AzNetworkInterface -NetworkInterface $nic31

#   create peering from vnet1 to vnet2 - needs to be done in both directions
$peering12_name = "vnettest-peering-vnet1-vnet2"
$peering12 = Add-AzVirtualNetworkPeering -Name $peering12_name -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.Id
$peering21_name = "vnettest-peering-vnet2-vnet1"
$peering21 = Add-AzVirtualNetworkPeering -Name $peering21_name -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.Id
Get-AzVirtualNetworkPeering -ResourceGroupName $rg_name -VirtualNetworkName $vnet1_name
Get-AzVirtualNetworkPeering -ResourceGroupName $rg_name -VirtualNetworkName $vnet2_name
