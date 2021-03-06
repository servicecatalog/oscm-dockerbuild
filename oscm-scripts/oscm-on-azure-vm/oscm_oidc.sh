#!/bin/sh

Green='\033[0;32m'
Cyan='\033[1;35m'
White='\033[1;37m'

echo -e -n "${Cyan}Enter the docker tag (the field may be empty): ${White}"
read dockerTag < /dev/tty

echo -e -n "${Cyan}Enter the hostname of your application (the field may be empty): ${White}"
read hostname < /dev/tty

echo -e -n "${Cyan}Enter the database password: ${White}"
read plainPwd < /dev/tty

echo -e -n "${Cyan}Enter the administrator password: ${White}"
read adminPwd < /dev/tty

echo -e -n "${Cyan}Enter the supplier password: ${White}"
read supplierPwd < /dev/tty

echo -e -n "${Cyan}Enter an email suffix (example: mydomain.onmicrosoft.com): ${White}"
read suffix < /dev/tty

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

  publicIP=$(curl ifconfig.me)
  appName=$hostname

  if [ -z "$dockerTag" ]; then
      dockerTag=latest
  fi

  if [ -z "$hostname" ]; then
      hostname=$publicIP
      appName=$publicIP":8081"
  fi

  sudo docker run --name deployer1 --rm -v /docker:/target -e HOST_FQDN=$hostname -e SAMPLE_DATA=true servicecatalog/oscm-deployer:$dockerTag

  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-deployer/templates/var.env.template
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-deployer/resources/proxy.conf.template

  administrator="administrator@${suffix}"
  supplier="supplier@${suffix}"
  customer="customer@${suffix}"
  reseller="reseller@${suffix}"

  sed -i 's/secret/'$plainPwd'/g' var.env.template
  sed -i 's/admin123/'$adminPwd'/g' var.env.template
  sed -i 's/administrator/'$administrator'/g' var.env.template
  sed -i 's/CONTROLLER_USER_PASS=supplier/CONTROLLER_USER_PASS='$supplierPwd'/g' var.env.template
  sed -i 's/supplier/'$supplier'/g' var.env.template
  sed -i 's/customer/'$customer'/g' var.env.template
  sed -i 's/reseller/'$reseller'/g' var.env.template
  sed -i 's/${HOST_FQDN}/'$hostname'/g' var.env.template
  sed -i 's/INTERNAL/OIDC/g' var.env.template
  sed -i 's/latest/'$dockerTag'/g' /docker/.env
  sed -i 's/${HOST_FQDN}/'$hostname'/g' /docker/.env
  sed -i 's/${HOST_FQDN}/'$hostname'/g' proxy.conf.template
  sed -i 's/${FQDN}/'$hostname'/g' proxy.conf.template
  sudo cp ./var.env.template /docker/var.env
  sudo docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true -e SAMPLE_DATA=true -e PROXY=true docker.io/servicecatalog/oscm-deployer:$dockerTag
  sudo cp ./proxy.conf.template /docker/config/oscm-proxy/data/proxy.conf

  echo
  echo -e "${Green}----------------------------------------------------------------------------------------"
  echo -e "${Green}                      OSCM application deployed on $publicIP                            "
  echo
  echo -e "${Green}                   Go to ${White} https://$appName/oscm-portal                       "
  echo -e "${Green}                                         and                                            "
  echo -e "${Green}            login as${White} $administrator ${Green}with password${White} $adminPwd   "
  echo
  echo -e "${Green}Register your application in Azure Active Directory and then configure tenant properties"
  echo
  echo -e "${Green}                                You can do it by                                         "
  echo -e "${Green}wget -O - https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/oscm-on-azure-vm/app-registration/start.sh | sudo bash"
  echo -e "${Green}----------------------------------------------------------------------------------------"
}

install_docker
install_docker_compose
install_oscm