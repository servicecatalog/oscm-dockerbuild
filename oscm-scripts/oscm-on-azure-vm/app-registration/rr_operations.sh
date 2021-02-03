#!/bin/bash

# This script defines request/response operation
response_file="response.json"

request_api(){
  if [ -z $3 ]; then
    headers=()
  else
    headers=(
      -H "Authorization: Bearer $3"
      -H "Content-Type: application/json"
    )
  fi

  curl -s -o $response_file -w "%{http_code}" -d "$2" "${headers[@]}" -X POST $1
}

request_api_get(){
  if [ -z $2 ]; then
    headers=()
  else
    headers=(
      -H "Authorization: Bearer $2"
      -H "Content-Type: application/json"
    )
  fi

  curl -s -o $response_file -w "%{http_code}" "${headers[@]}" -X GET $1
}

handle_response(){
  if [[ $1 != 2* ]]; then
    error=$(cat $response_file | jq -r ".error")
    echo "$1: Request failed with error: $error, please check response.json for details"
    exit 1
  else
    echo "$1: Request successful"
  fi
}

get_from_response(){
  cat $response_file | jq -r ".$1"
}
