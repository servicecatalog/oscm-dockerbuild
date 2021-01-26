#!/bin/bash

. ./steps.sh

#Provide Azure AD credentials
client_id=""
client_secret=""
tenant_name=""

#Provide application properties
app_display_name=""
app_redirect_url=""

prepare_input

get_access_token

register_new_application

create_service_principal

create_application_secret

grant_consent

prepare_properties_for_tenant
