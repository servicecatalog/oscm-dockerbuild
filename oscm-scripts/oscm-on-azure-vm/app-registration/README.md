## Register the OSCM in Azure Active Directory for the OIDC mode

The package contains the OSCM application register script for OIDC mode in Azure Active Directory.

##### Run script and follow the prompts

```wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/start.sh | bash```  

------------------------------------------------------------OR----------------------------------------------------------

##### Download starting script:

```wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/start.sh```  

##### Then change the permission level for the start.sh file

```chmod +x ./start.sh```

##### Run the script and follow the prompts

```./start.sh```

---------------------------------------------------------IMPORTANT!-----------------------------------------------------
Before registering the OSCM application, service principal with proper permissions must be created in Azure AD.
