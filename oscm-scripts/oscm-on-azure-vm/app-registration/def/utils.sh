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

  handle_response $auth_response

  access_token=$(get_from_response "access_token")
}

prepare_properties_for_tenant(){
  echo "START: Preparing tenant.properties..."
  sed -e "s/\${clientId}/$app_appId/" -e "s/\${clientSecret}/$secret/" -e "s/\${hostname}/$app_hostname/" -e "s/\${tenant}/$tenant_name/"  templates/tenant-template.properties > output/tenant-default.properties
  if [ $? -ne 0 ]; then
    echo "Tenant data preparation failed"
    exit 1
  else
    echo "Tenant data preparation was successful"

    Green='\033[0;32m'
    White='\033[1;37m'
    echo -e "${Green}Application registered successfully in Azure Active Directory"
    echo -e "${Green}Now copy the ${White}output/tenant-default.properties ${Green}file to the path ${White}/docker/config/oscm-identity/tenants"
  fi
}
