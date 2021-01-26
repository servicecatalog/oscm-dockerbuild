#!/bin/bash

Green='\033[0;32m'
Cyan='\033[1;35m'
White='\033[1;37m'

resourceGroupName=myOSCMGroup
vmName=myOSCM
username=oscmadmin
isExist=$(az group exists -n $resourceGroupName)

echo -e -n "${Cyan}Enter the password you want to use for ssh login: \n${White}"
read -s plainPwd < /dev/tty

delete_resource_group_if_exist() {
  if [[ $isExist == true ]]; then
    az group delete --name $resourceGroupName
    echo "Resource group deleted"
  fi
}

create_vm() {
  az group create -l germanywestcentral -n $resourceGroupName
  echo "Resource group created"
  az vm create --resource-group $resourceGroupName --name $vmName --image UbuntuLTS --admin-username $username --admin-password $plainPwd --generate-ssh-keys --size Standard_D2s_v3
  echo "Virtual machine created"
}

vm_conf() {
  az vm open-port --port 80 --resource-group $resourceGroupName --name $vmName --priority 100
  az vm open-port --port 8080-8081 --resource-group $resourceGroupName --name $vmName --priority 200
  az vm open-port --port 8880-8881 --resource-group $resourceGroupName --name $vmName --priority 300
  az vm open-port --port 8681 --resource-group $resourceGroupName --name $vmName --priority 400
  az vm open-port --port 443 --resource-group $resourceGroupName --name $vmName --priority 500
  az vm auto-shutdown -g $resourceGroupName -n $vmName --time 2000
  echo "Virtual machine available at port 80 and is set to auto-shutdown"
}

login_to_vm() {
  publicIp=$(az vm show -d -g $resourceGroupName -n $vmName --query publicIps -o tsv)

  echo -e "${Green}----------------------------------------------------------------------------------------------------------------------------------------------------------------------"
  echo -e "${Green}Now copy&paste <- wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/OSCM_on_Azure_VM/deploy_oscm.sh | sudo bash ->"
  echo -e "${Green}----------------------------------------------------------------------------------------------------------------------------------------------------------------------"
  echo -e "${White}"

  ssh $username@"$publicIp"
}

delete_resource_group_if_exist
create_vm
vm_conf
login_to_vm
