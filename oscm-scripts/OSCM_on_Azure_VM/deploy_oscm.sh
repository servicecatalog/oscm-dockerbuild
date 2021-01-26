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

  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/OSCM_on_Azure_VM/conf.env
  sudo wget https://raw.githubusercontent.com/servicecatalog/oscm-dockerbuild/master/oscm-scripts/OSCM_on_Azure_VM/proxy_conf.conf

  echo -e -n "${Cyan}Enter a database password: \n${White}"
  read -s plainPwd < /dev/tty

  pwKey=""
  for value in $plainPwd $plainPwd '1234'; do
    pwKey+="$value"
  done

  echo -e -n "${Cyan}Enter a admin password: \n${White}"
  read -s adminPwd < /dev/tty

  sed -i 's/password/'$plainPwd'/g' conf.env
  sed -i 's/pwKey/'$pwKey'/g' conf.env
  sed -i 's/adminpassword/'$adminPwd'/g' conf.env
  sed -i 's/vm_public_ip/'$publicIP'/g' conf.env
  sed -i 's/vm_public_ip/'$publicIP'/g' proxy_conf.conf
  sudo cp ./conf.env /docker/var.env
  sudo docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true -e SAMPLE_DATA=true -e PROXY=true docker.io/servicecatalog/oscm-deployer:latest
  sudo cp ./proxy_conf.conf /docker/config/oscm-proxy/data/proxy.conf

  echo
  echo -e "${Green}----------------------------------------------------------------------------------------"
  echo -e "${Green}                      OSCM application deployed on $publicIP                            "
  echo
  echo -e "${Green}Register your application in Azure Active Directory and then configure tenant properties"
  echo -e "${Green}----------------------------------------------------------------------------------------"
}

install_docker
install_docker_compose
install_oscm