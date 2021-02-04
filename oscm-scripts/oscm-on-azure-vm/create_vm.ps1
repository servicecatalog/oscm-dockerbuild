
$resourceGroupName = "myOSCMGroup"
$vmName            = "myOSCM"
$username          = "oscmadmin"
$isExist           = $(az group exists -n $resourceGroupName)

Write-Host -f Magenta "Enter the password you want to use for ssh login: "
$pwd_string        = Read-Host -AsSecureString
$plainPwd          = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd_string))

function delete_resource_group_if_exist {
  if ($isExist -eq $true) {
    az group delete --name $resourceGroupName
    Write-Host -f Yellow "Resource group deleted"
  }
}

function create_vm {
  az group create -l germanywestcentral -n $resourceGroupName
  Write-Host -f Green "Resource group created"
  az vm create --resource-group $resourceGroupName --name $vmName --image UbuntuLTS --admin-username $username --admin-password $plainPwd --generate-ssh-keys --size Standard_D2s_v3
  Write-Host -f Green "Virtual machine created"
}

function vm_conf {
  az vm open-port --port 80 --resource-group $resourceGroupName --name $vmName --priority 100
  az vm open-port --port 443 --resource-group $resourceGroupName --name $vmName --priority 110
  az vm open-port --port 8080-8881 --resource-group $resourceGroupName --name $vmName --priority 200
  az vm open-port --port 9091 --resource-group $resourceGroupName --name $vmName --priority 210
  az vm auto-shutdown -g $resourceGroupName -n $vmName --time 1700
  Write-Host "Virtual machine available at port 80 and is set to auto-shutdown"
}

function login_to_vm {
 $publicIp = $(az vm show -d -g $resourceGroupName -n $vmName --query publicIps -o tsv)

 Write-Host -f Green "----------------------------------------------------------------------------------------------------------------------------"
 Write-Host -f Green "Now copy&paste <- wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/deploy_oscm.sh | sudo bash ->"
 Write-Host -f Green "----------------------------------------------------------------------------------------------------------------------------"

 ssh $username@"$publicIp"
}

delete_resource_group_if_exist
create_vm
vm_conf
login_to_vm