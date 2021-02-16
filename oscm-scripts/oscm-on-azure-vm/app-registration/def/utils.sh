install_jq(){
  echo "START: Checking if jq is exist"
  dpkg -s jq &> /dev/null

  if [ $? -ne 0 ]; then
    sudo apt-get install -y jq
  else
    echo "Jq already installed"
  fi
}

show_menu(){
  sleep 1
  echo -e "${Cyan}\nFollowing options are possible:\n"
  echo "1 - Register new application (for oscm-identity initial setup)"
  echo "2 - Create new user"
  echo "3 - Create new group"
  echo "4 - Assign user to group"
  echo "Q - Quit"
  echo -e -n "\nPlease select an option for the next action: ${White}"
}

initialize_script(){
  echo -e "${Cyan}\nWelcome. This is a script for managing data in Azure AD. To initialize it, follow the next steps.\n"
  is_initialized=0
  while [ $is_initialized -eq 0 ]
  do
    echo -e -n "${Cyan}Enter an application (client) ID: ${White}"
    read client_id < /dev/tty
    echo -e -n "${Cyan}Enter a client secret of your application: ${White}"
    read client_secret < /dev/tty
    echo -e -n "${Cyan}Enter the tenant name in Azure AD: ${White}"
    read tenant_name < /dev/tty
    get_access_token
  done
  echo -e "${Green}\nScript has been successfully initialized."
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
