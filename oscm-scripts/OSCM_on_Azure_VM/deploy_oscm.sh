#!/bin/sh

install_docker () {
  sudo apt-get udpate
  sudo apt-get -y install \
          apt-transport-https \
          ca-certificates \
          curl \
          gnupg-agent \
          software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get udpate
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io
}

install_docker_compose () {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

install_oscm () {
  Green='\033[0;32m'
  Cyan='\033[1;35m'
  White='\033[1;37m'
  sudo docker run --name deployer1 --rm -v /docker:/target -e SAMPLE_DATA=true servicecatalog/oscm-deployer:latest
  publicIP=$(curl ifconfig.me)

  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-deployer/templates/var.env.template
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-deployer/templates/env.template
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-deployer/resources/proxy.conf.template

  echo -e -n "${Cyan}Enter a database password: ${White}"
  read -s plainPwd < /dev/tty

  echo -e -n "${Cyan}Enter a admin password: ${White}"
  read -s adminPwd < /dev/tty

  echo -e -n "${Cyan}Enter a email suffix (mydomain.onmicrosoft.com): ${White}"
  read suffix < /dev/tty

  administrator="administrator@${suffix}"
  supplier="supplier@${suffix}"
  customer="customer@${suffix}"
  reseller="reseller@${suffix}"

  sed -i 's/secret/'$plainPwd'/g' var.env.template
  sed -i 's/admin123/'$adminPwd'/g' var.env.template
  sed -i 's/${HOST_FQDN}/'$publicIP'/g' var.env.template
  sed -i 's/administrator/'$administrator'/g' var.env.template
  sed -i 's/supplier/'$supplier'/g' var.env.template
  sed -i 's/customer/'$customer'/g' var.env.template
  sed -i 's/reseller/'$reseller'/g' var.env.template
  sed -i 's/INTERNAL/OIDC/g' var.env.template
  sed -i 's/${HOST_FQDN}/'$publicIP'/g' env.template
  sed -i 's/${HOST_FQDN}/'$publicIP'/g' proxy.conf.template
  sed -i 's/${FQDN}/'$publicIP'/g' proxy.conf.template
  sudo cp ./var.env.template /docker/var.env
  sudo cp ./env.template /docker/.env
  sudo docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true -e SAMPLE_DATA=true -e PROXY=true docker.io/servicecatalog/oscm-deployer:latest
  sudo cp ./proxy.conf.template /docker/config/oscm-proxy/data/proxy.conf

  echo
  echo -e "${Green}----------------------------------------------------------------------------------------"
  echo -e "${Green}                      OSCM application deployed on $publicIP                            "
  echo
  echo -e "${Green}Register your application in Azure Active Directory and then configure tenant properties"
  echo -e "${Green}You can do it by <- wget https://github.com/servicecatalog/oscm-dockerbuild/tree/master/oscm-scripts/OSCM_on_Azure_VM/app_registration ->"
  echo -e "${Green}And than execute start.sh from that package"
  echo -e "${Green}----------------------------------------------------------------------------------------"
}

install_docker
install_docker_compose
install_oscm