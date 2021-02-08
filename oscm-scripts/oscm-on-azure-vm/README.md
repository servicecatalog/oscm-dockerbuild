## Installing OSCM on Azure VM

The package contains the OSCM installation scripts along with the installation of a virtual machine on Azure.

- The create_vm.ps1 script installs a virtual machine on the Azure platform and is launched using PowerShell commands.
- The create_vm.sh script installs a virtual machine on the Azure platform and is launched using commands in the Linux terminal. 
- The oscm_oidc.sh script installs the OSCM in OIDC mode and is launched using commands in the Linux terminal. 
- The oscm_internal.sh script installs the OSCM in Internal mode and is launched using commands in the Linux terminal. 

#### Log in to your Azure account, the login window can be opened with the command:

```az login```  OR  ```az login -u USERNAME -p PASSWORD```

#### To run a script on Windows, run the following commands in PowerShell:  

```[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12```  
```$OSCMWithAzureScript = Invoke-WebRequest https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/create_vm.ps1```  
```Invoke-Expression $($OSCMWithAzureScript.Content)```  

#### To run a script on Linux, run the following command:  

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/create_vm.sh | sudo bash```  

And then follow the displayed messages

IMPORTANT! Before installing OSCM in OIDC mode, you need to create a tenant in the Azure portal. More information can be found at the link below: 

https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant#create-a-new-tenant-for-your-organization 
