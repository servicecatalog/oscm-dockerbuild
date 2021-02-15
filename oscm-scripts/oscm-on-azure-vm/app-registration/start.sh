#!/bin/sh

Cyan='\033[1;35m'
White='\033[1;37m'
Red='\033[0;31m'
Green='\033[0;32m'

. def/utils.sh
. def/handlers.sh
. def/application.sh
. def/user.sh
. def/group.sh

#build_dependencies

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

initialize_script
show_menu

while :
do
  read sample_data_option
  case $sample_data_option in
  1)
    echo -e -n "${Cyan}Specify application name: ${White}"
    read app_display_name < /dev/tty
    echo -e -n "${Cyan}Specify the hostname of your application (used in redirect url when authenticating with Azure AD): ${White}"
    read app_hostname < /dev/tty

    register_new_application $app_display_name $app_hostname
    create_service_principal
    create_application_secret
    get_graph_api_id
    grant_consent
    prepare_properties_for_tenant
    show_menu
    ;;
	2)
    echo -e -n "${Cyan}Specify user name: ${White}"
    read user_name < /dev/tty
    echo -e -n "${Cyan}Specify user password: ${White}"
    read user_password < /dev/tty
    create_user $user_name $user_password
    if [ $? -eq 0 ]; then
      while :
      do
        echo -e -n "${Cyan}\nWould you like this user to be in administrator role? (Y/N) ${White}"
        read is_admin < /dev/tty
        case $is_admin in
          Y)
            assign_role_to_user "Global Administrator" $user_id
            break
            ;;
          N)
            echo -e "${Green}\nNo role has been assigned."
            break
            ;;
          *)
            ;;
        esac
      done
    fi
    show_menu
		;;
	3)
    echo -e -n "${Cyan}Specify group name: ${White}"
    read group_name < /dev/tty
    create_group $group_name
		show_menu
		;;
  4)
    echo -e -n "${Cyan}Specify user id: ${White}"
    read user_id < /dev/tty
  echo -e -n "${Cyan}Specify group id: ${White}"
    read group_id < /dev/tty
    assign_user_to_group $user_id $group_id
    show_menu
    ;;
  Q)
    echo -e "${Cyan}\nThank you. Exiting...."
    break
    ;;
	*)
		echo -e "${Red}\nInvalid option."
    show_menu
		;;
  esac
done
