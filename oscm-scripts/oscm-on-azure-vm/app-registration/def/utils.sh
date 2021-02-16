install_jq(){
  echo "START: Checking if jq is exist"
  dpkg -s jq &> /dev/null

  if [ $? -ne 0 ]; then
    sudo apt-get install -y jq
  else
    echo "Jq already installed"
  fi
}

get_access_token(){
  echo "START: Retrieving access token..." > output/output.logs
  auth_data="grant_type=client_credentials&scope=https://graph.microsoft.com/.default&client_id=$client_id&client_secret=$client_secret"
  auth_response=$(request_api "https://login.microsoftonline.com/$tenant_name/oauth2/v2.0/token" $auth_data)

  handle_auth_response $auth_response

  if [ $? -eq 0 ]; then
    access_token=$(get_from_response "access_token")
    is_initialized=1
  else
    is_initialized=0
  fi
}

prepare_properties_for_tenant(){
  echo "START: Preparing tenant.properties..." >> output/output.logs
  sed -e "s/\${clientId}/$app_appId/" -e "s/\${clientSecret}/$secret/" -e "s/\${hostname}/$app_hostname/" -e "s/\${tenant}/$tenant_name/"  templates/tenant-template.properties > output/tenant-default.properties
  if [ $? -ne 0 ]; then
    echo "Tenant data preparation failed" >> output/output.logs
    exit 1
  else
    echo "Tenant data preparation was successful" >> output/output.logs

    echo -e "\n${Green}Application registered successfully in Azure Active Directory"
    echo -e "${Green}Tenant properties can be found in: ${White}output/tenant-default.properties"
  fi
}

build_dependencies() {
  -e "${Cyan}\nChecking dependencies...\n"

  #Download necessary scripts
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/def/utils.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/def/handlers.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/def/application.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/def/user.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/def/group.sh

  #Download necessary templates
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/templates/tenant-template.properties
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/templates/user-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/templates/application-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/azure_sample_data/oscm-scripts/oscm-on-azure-vm/app-registration/templates/group-template.json

  #Create output diretory
  if [ -d output ]; then
    mkdir output
  fi

  if [ -f def/utils.sh -a -f def/handlers.sh -a -f def/application.sh -a -f def/user.sh -a -f def/group.sh -a -f templates/user-template.json -a -f templates/group-template.json -a -f templates/application-template.json -a -f templates/tenant-template.properties -a -d output ]; then
    echo -e "${Green}Dependencies are ready"
  else
    echo -e -n "${Red}Building dependencies failed!\n"
    echo -e -n "Please check your proxy settings.\n"
    echo -e -n "You can also download files manually from\n"
    echo "${White}https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/OSCM_on_Azure_VM/app_registration"
    exit 1
  fi
}
