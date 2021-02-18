#Copyright FUJITSU LIMITED 2021

#!/bin/bash
# This script defines application related operations in Azure AD

prepare_application_input(){
  echo "START: Preparing application.json..." >> output/output.logs
  sed -e "s/\${displayName}/$1/" -e "s/\${hostname}/$2/" templates/application-template.json > output/application.json
  if [ $? -ne 0 ]; then
    echo "Input data preparation failed" >> output/output.logs
    exit 1
  else
    echo "Input data preparation was successful" >> output/output.logs
  fi
}

register_new_application(){
  prepare_application_input $1 $2
  echo "START: Registering new application..." >> output/output.logs
  app_response=$(request_api "https://graph.microsoft.com/v1.0/applications" "@output/application.json" $access_token)

  handle_response $app_response

  app_id=$(get_from_response "id")
  app_appId=$(get_from_response "appId")
}

get_graph_api_id(){
  echo "START: Getting Graph API id..." >> output/output.logs
  graph_response=$(request_api_get "https://graph.microsoft.com/v1.0/servicePrincipals?\$filter=displayName%20eq%20'Microsoft%20Graph'" $access_token)

  handle_response $graph_response

  graph_api_id=$(get_from_response "value | .[0].id")
}

create_service_principal(){
  echo "START: Creating service principal for application..." >> output/output.logs
  sp_data="{\"appId\":\"$app_appId\"}"
  sp_response=$(request_api "https://graph.microsoft.com/v1.0/servicePrincipals" $sp_data $access_token)

  handle_response $sp_response

  principal_id=$(get_from_response "id")
}

create_application_secret(){
  echo "START: Creating secret for application..." >> output/output.logs
  secret_response=$(request_api "https://graph.microsoft.com/v1.0/applications/$app_id/addPassword" "" $access_token)

  handle_response $secret_response

  secret=$(get_from_response "secretText")
}

grant_consent(){
  echo "START: Granting admin consent for application permission..." >> output/output.logs
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
