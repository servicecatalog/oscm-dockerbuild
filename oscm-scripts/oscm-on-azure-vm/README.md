## Installing OSCM on Azure VM

The package contains the OSCM installation scripts along with the installation of a virtual machine on Azure.

- The create_vm.ps1 script installs a virtual machine on the Azure platform and is launched using PowerShell commands.
- The create_vm.sh script installs a virtual machine on the Azure platform and is launched using commands in the Linux terminal. 
- The oscm_oidc.sh script installs the OSCM in OIDC mode and is launched using commands in the Linux terminal. 
- The oscm_internal.sh script installs the OSCM in Internal mode and is launched using commands in the Linux terminal. 
- The app-registration folder that contains the scripts to register the OSCM application in Azure Active Directory.

### 1. Preparation
##### To run the scripts you must first install the Azure CLI 

Information about installation for each operating systems as well as checking the update to the latest version can be found at the link:    
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

-------------------------------------------------------IMPORTANT!-------------------------------------------------------

Before installing OSCM in OIDC mode, you need to create a tenant in the Azure portal. More information can be found at the link below:  
https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant#create-a-new-tenant-for-your-organization 

### 2. Installation Virtual Machine at Azure Portal
##### Log in to your Azure account 

Open login window with the command: ```az login```  

----------------------------------------------------------OR------------------------------------------------------------   

Log in with the command: ```az login -u USERNAME -p PASSWORD```

##### To run a script on Windows, run the following commands in PowerShell:  

```[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12```  
```$OSCMWithAzureScript = Invoke-WebRequest https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/create_vm.ps1```  
```Invoke-Expression $($OSCMWithAzureScript.Content)```  

##### To run a script on Linux, run the following command:  

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/create_vm.sh | sudo bash```  

After the installation is completed, information will be displayed whether you really want to log into the VM, and after accepting it, 
a request for a password for the virtual machine (the password which was provided right after running the script) 

### 3. Deploy OSCM on Ubuntu 

##### To run OSCM in Internal mode, run the following command:

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/oscm_internal.sh | sudo bash``` 

##### To run OSCM in OIDC mode, run the following command:

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/oscm_oidc.sh | sudo bash``` 

### 4. Configuration OSCM in OIDC mode

Information about how to configure the OSCM application in Azure Active Directory can be found at the link:  
https://github.com/servicecatalog/oscm-dockerbuild/blob/master/oscm-scripts/oscm-on-azure-vm/app-registration/README.md