#!/bin/bash
# This script defines steps for registering new tenant application in Azure AD

. ./rr_operations.sh

tenant_properties="tenant.properties"

prepare_input(){
  echo "START: Preparing application.json..."
  sed -e "s/\${displayName}/$app_display_name/" -e "s/\${redirectUrl}/$app_redirect_url/" application-template.json > application.json
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
  app_response=$(request_api "https://graph.microsoft.com/v1.0/applications" "@application.json" $access_token)

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

grant_consent(){
  echo "START: Granting admin consent for application permission..."
  appRoles=(
    "df021288-bdef-4463-88db-98f22de89214"
    "62a82d76-70ea-41e2-9197-370581804d09"
    "19dbc75e-c2e2-444c-a770-ec69d8559fc7"
  )

  for appRoleId in "${appRoles[@]}"
  do
    consent_data="{\"principalId\":\"$principal_id\",\"resourceId\":\"fb132085-49c3-49eb-abe2-55842e6dde11\",\"appRoleId\":\"$appRoleId\"}"
    consent_response=$(request_api "https://graph.microsoft.com/v1.0/servicePrincipals/$principal_id/appRoleAssignments" $consent_data $access_token)
    handle_response $consent_response
  done
}

prepare_properties_for_tenant(){
  echo "START: Preparing tenant.properties..."
  sed -e "s/\${clientId}/$app_appId/" -e "s/\${clientSecret}/$secret/" -e "s/\${redirectUrl}/$app_redirect_url/" tenant-template.properties > tenant.properties
  if [ $? -ne 0 ]; then
    echo "Tenant data preparation failed"
    exit 1
  else
    echo "Tenant data preparation was successful"
  fi
}
