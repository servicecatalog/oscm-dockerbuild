#!/bin/bash
# This script defines steps for registering new tenant application in Azure AD

. ./rr_operations.sh

tenant_properties="output/tenant.properties"

install_jq(){
  echo "START: Checking if jq is exist"
  dpkg -s jq &> /dev/null

  if [ $? -ne 0 ]; then
    sudo apt-get install -y jq
  else
    echo "Jq already installed"
  fi
}

prepare_input(){
  echo "START: Preparing application.json..."
  sed -e "s/\${displayName}/$app_display_name/" -e "s/\${hostname}/$app_hostname/" templates/application-template.json > output/application.json
  if [ $? -ne 0 ]; then
    echo "Input data preparation failed"
    exit 1
  else
    echo "Input data preparation was successful"
  fi
}

get_access_token(){
  echo "START: Retrieving access token..."
  auth_data="grant_type=client_credentials&scope=https://graph.microsoft.com/.default&client_id=$client_id&client_secret=$client_secret"
  auth_response=$(request_api "https://login.microsoftonline.com/$tenant_name/oauth2/v2.0/token" $auth_data)

  handle_response $auth_response

  access_token=$(get_from_response "access_token")
}

register_new_application(){
  echo "START: Registering new application..."
  app_response=$(request_api "https://graph.microsoft.com/v1.0/applications" "@output/application.json" $access_token)

  handle_response $app_response

  app_id=$(get_from_response "id")
  app_appId=$(get_from_response "appId")
}

create_service_principal(){
  echo "START: Creating service principal for application..."
  sp_data="{\"appId\":\"$app_appId\"}"
  sp_response=$(request_api "https://graph.microsoft.com/v1.0/servicePrincipals" $sp_data $access_token)

  handle_response $sp_response

  principal_id=$(get_from_response "id")
}

create_application_secret(){
  echo "START: Creating secret for application..."
  secret_response=$(request_api "https://graph.microsoft.com/v1.0/applications/$app_id/addPassword" "" $access_token)

  handle_response $secret_response

  secret=$(get_from_response "secretText")
}

get_graph_api_id(){
  echo "START: Getting Graph API id..."
  graph_response=$(request_api_get "https://graph.microsoft.com/v1.0/servicePrincipals?\$filter=displayName%20eq%20'Microsoft%20Graph'" $access_token)

  handle_response $graph_response

  graph_api_id=$(get_from_response "value | .[0].id")
}

grant_consent(){
  echo "START: Granting admin consent for application permission..."
  appRoles=(
    "df021288-bdef-4463-88db-98f22de89214"
    "62a82d76-70ea-41e2-9197-370581804d09"
    "19dbc75e-c2e2-444c-a770-ec69d8559fc7"
  )

  for appRoleId in "${appRoles[@]}"
  do
    consent_data="{\"principalId\":\"$principal_id\",\"resourceId\":\"$graph_api_id\",\"appRoleId\":\"$appRoleId\"}"
    consent_response=$(request_api "https://graph.microsoft.com/v1.0/servicePrincipals/$principal_id/appRoleAssignments" $consent_data $access_token)
    handle_response $consent_response
  done
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
    echo -e "${Green}Application registered successfully in  Azure Active Directory"
    echo -e "${Green}Now copy the ${White}tenant-default.properties ${Green}file to the path ${White}/docker/config/oscm-identity/tenants"
  fi
}
