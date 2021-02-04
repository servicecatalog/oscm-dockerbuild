## Register the OSCM in Azure Active Directory for the OIDC mode

The package contains the OSCM register script for OIDC mode in Azure Active Directory. 

#### Run script and follow the prompts 

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/start.sh | sudo bash```  

------------------------------------------------------------OR---------------------------------------------------------------------------

#### Download files from the GitHub repository:

```https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/oscm-on-azure-vm/app-registration```  

#### Then change the permission level for the start.sh file 

```chmod +x ./start.sh```

#### Run the script and follow the prompts 

```./start.sh```

IMPORTANT! Before registering the OSCM application, you must create a registry administrator. More information can be found at the link below: 

https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app