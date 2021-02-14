#!/bin/bash
# This script defines group related operations in Azure AD

# Prepares group.json data to be used for user creation
#
# param $1 - name of the group to be created
prepare_group_data_input(){
  echo "START: Preparing group.json..." >> output/output.logs
  sed -e "s/\${tenantName}/$tenant_name/" -e "s/\${groupName}/$1/" templates/group-template.json > output/group.json
  if [ $? -ne 0 ]; then
    echo "Group data preparation failed" >> output/output.logs
    exit 1
  else
    echo "Group data preparation was successful" >> output/output.logs
  fi
}

# Creates group in Azure AD
#
# param $1 - name of the group to be created
create_group(){
  prepare_group_data_input "$1"

  echo "START: Creating group..." >> output/output.logs
  group_response=$(request_api "https://graph.microsoft.com/v1.0/groups" "@output/group.json" $access_token)

  handle_response $group_response

  group_id=$(get_from_response "id")
  echo -e "${Green}\nGroup successfully created - group id: $group_id\n"
}

# Assigns role to the user in Azure AD
#
# param $1 - id of the user
# param $2 - id of the group which user will become member of
assign_user_to_group(){
  echo "START: Assigning user..." >> output/output.logs
  assign_data="{\"@odata.id\":\"https://graph.microsoft.com/v1.0/users/$1\"}"
  assign_response=$(request_api "https://graph.microsoft.com/v1.0/groups/$2/members/\$ref" $assign_data $access_token)

  handle_response $assign_response
  echo -e "${Green}\nUser successfully assigned to the group\n"
}
