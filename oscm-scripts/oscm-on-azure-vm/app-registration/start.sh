#Copyright FUJITSU LIMITED 2021

#!/bin/bash

Cyan='\033[1;35m'
White='\033[1;37m'
Red='\033[0;31m'
Green='\033[0;32m'

build_dependencies() {
  echo -e "${Cyan}\nChecking dependencies...\n"

  #Download necessary scripts
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/utils.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/handlers.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/application.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/user.sh
  wget -P def https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/def/group.sh

  #Download necessary templates
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/tenant-template.properties
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/user-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/application-template.json
  wget -P templates https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/templates/group-template.json

  #Create output diretory
  if [ ! -d output ]; then
    mkdir output
  fi

  if [ -f def/utils.sh -a -f def/handlers.sh -a -f def/application.sh -a -f def/user.sh -a -f def/group.sh -a -f templates/user-template.json -a -f templates/group-template.json -a -f templates/application-template.json -a -f templates/tenant-template.properties -a -d output ]; then
    echo -e "${Green}Dependencies are ready"
  else
    echo -e "${Red}Building dependencies failed!"
    echo -e "Please check your proxy settings."
    echo -e "You can also download files manually from"
    echo -e "${White}https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/OSCM_on_Azure_VM/app_registration\n"
    exit 1
  fi
}

build_dependencies

. def/utils.sh
. def/handlers.sh
. def/application.sh
. def/user.sh
. def/group.sh

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
