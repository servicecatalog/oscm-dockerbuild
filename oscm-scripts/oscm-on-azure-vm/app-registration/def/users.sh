#!/bin/bash
# This script defines user/role related operations in Azure AD

. ./rr_operations.sh

# Prepares user.json data to be used for user creation
#
# param $1 - userid of the user to be created
# param $2 - password of the user to be created
# param $3 - dispaly name of the user to be created
prepare_user_data_input(){
  echo "START: Preparing user.json..."
  sed -e "s/\${tenantName}/$tenant_name/" -e "s/\${userId}/$1/" -e "s/\${password}/$2/" -e "s/\${displayName}/$3/" templates/user-template.json > output/user.json
  if [ $? -ne 0 ]; then
    echo "User data preparation failed"
    exit 1
  else
    echo "User data preparation was successful"
  fi
}

# Creates user in Azure AD
#
# param $1 - userid of the user to be created
# param $2 - password of the user to be created
# param $3 - dispaly name of the user to be created
create_user(){
  prepare_user_data_input "$1" "$2" "$3"

  echo "START: Creating user..."
  user_response=$(request_api "https://graph.microsoft.com/v1.0/users" "@output/user.json" $access_token)

  handle_response $user_response

  user_id=$(get_from_response "id")
}

# Retrievs id of the role in Azure AD
#
# param $1 - name of the role
get_role_id(){
  echo "START: Getting $1 role..."

  role_name=$(echo $1 | sed 's/ /%20/g')
  role_response=$(request_api_get "https://graph.microsoft.com/v1.0/directoryRoles?\$filter=displayName%20eq%20'$role_name'" $access_token)

  handle_response $role_response

  role_id=$(get_from_response "value | .[0].id")
}

# Assigns role to the user in Azure AD
#
# param $1 - id of the role
# param $2 - id of the user which role will be assigned to
assign_role_to_user(){
  echo "START: Assigning role..."
  assign_data="{\"@odata.id\":\"https://graph.microsoft.com/v1.0/users/$2\"}"
  assign_response=$(request_api "https://graph.microsoft.com/v1.0/directoryRoles/$1/members/\$ref" $assign_data $access_token)

  handle_response $assign_response
}
