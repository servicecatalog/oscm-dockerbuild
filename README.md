# Quick start OSCM with Docker
This is a quick start guide intended to help you start up a basic installation of [Open Service Catalog Manager (OSCM)](https://openservicecatalogmanager.org/) with Docker and Docker Compose as quickly as possible. For more advanced configuration and usage please refer to the individual Docker containers' documentation. You can find the links in the [Resources](#resources) section.

# Prerequisites
A Linux system with:

* [git](https://git-scm.com/)
* [gettext](https://www.gnu.org/software/gettext/)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

We will refer to the Linux system with Docker installed as the *docker host*.

For initial tests, we recommend:

* 2 CPU cores
* 8GB of RAM
* 20GB of disk space

Please note that this minimum configuration is not suitable for production use.

# Setup
## Prepare directories on the host
We require a directory on the docker host which holds the persistent data for the database. This directory will be mounted into the database container.

```sh
mkdir -p /docker/data/oscm-db/data
```

## Prepare Docker Compose files
Check out our Docker Compose file templates from the repository.

```sh
# Optional installation of git for Red Hat/Fedora based distributions
sudo yum -y install git
# Optional installation of git for Debian/Ubuntu based distributions
sudo apt-get -y install git
git clone TODO
```

We will set some configuration variables to complete the templates:

```sh
# The base data directory we created
export WORKDIR=/docker
# This can be the docker host's fully qualified host name (FQDN) or IP address
export HOST_FQDN=hostname.fqdn
# FQDN or IP address of an open mail server if you have one - otherwise 'none'
export SMTP_HOST=mailserver.fqdn
```

Next we use the *envsubst* command to fill the Docker Compose file templates with the values of our variables. If the *envsubst* command is not available on your system, you can usually get it by installing your distribution's *gettext* package.

```sh
# Optional installation of envsubst for Red Hat/Fedora based distributions
sudo yum -y install gettext
# Optional installation of envsubst for Debian/Ubuntu based distributions
sudo apt-get -y install gettext
# Substitute the variables to complete Docker Compose environment files in /docker
envsubst '$WORKDIR' < docker-compose/env.template > /docker/.env
envsubst '$HOST_FQDN $SMTP_HOST' < docker-compose/var.env.template > /docker/var.env
# Copy the Docker Compose files to /docker
cp docker-compose/docker-compose-initdb.yml /docker/docker-compose-initdb.yml
cp docker-compose/docker-compose-oscm.yml /docker/docker-compose-oscm.yml
```

## Initialize the databases
We will start a temporary database container and several database initialization containers. This will create the initial database schemas required for running OSCM.

```sh
# Change to the /docker directory, otherwise Docker Compose will not pick up the .env file
cd /docker
# Start a database container
docker-compose -f /docker/docker-compose-initdb.yml up -d oscm-db
# Initialize the database for the core application
docker-compose -f /docker/docker-compose-initdb.yml up oscm-initdb-core
# Initialize a supporting database for the core application
docker-compose -f /docker/docker-compose-initdb.yml up oscm-initdb-jms
# Initialize the database for the Asynchronous Provisioning Platform
docker-compose -f /docker/docker-compose-initdb.yml up oscm-initdb-app
# Initialize the database for the AWS provider
docker-compose -f /docker/docker-compose-initdb.yml up oscm-initdb-controller-aws
# Initialize the database for the OpenStack provider
docker-compose -f /docker/docker-compose-initdb.yml up oscm-initdb-controller-openstack
# Stop the database container
docker-compose -f /docker/docker-compose-initdb.yml stop
# Remove all stopped containers
docker-compose -f /docker/docker-compose-initdb.yml rm -f
```

## Start OSCM
Finally we will start all the application containers.

```sh
docker-compose -f /docker/docker-compose-oscm.yml up -d
```

# Login to the administration portal
The application will take a few minutes to start up. The less CPU power you have, the longer it will take. Once everything has started, you may access the OSCM administration portal in your web browser using the FQDN or IP address you specified earlier.

`http://hostname.fqdn:8080/oscm-portal/`

The initial login credentials are:

* Username: `administrator`
* Password: `admin123`

# Enable login to APP and controllers
In order to be able to login to the Asynchronous Provisioning Platform (APP) and its service controllers, we will make some quick changes in the administration portal.

* Login to the administration portal
* *Operation* -> *Manage organization*
* *Organization ID*: Enter `PLATFORM_OPERATOR`
* Enable the following *Organization role*s:
    * Supplier
    * Technology provider
* Fill in the mandatory fields (red asterisks)
* Click *Save*
* *Account* -> *Manage users* (Attention: **Not** *Operation* -> *Manage users*)
* Click on *administrator*
* Enter your Email address
* Enable all *User role*s:
* Click *Save*
* *Logout* of the administration portal and login again to enable the changes

Now you will be able to login to the APP:

`http://hostname.fqdn:8880/oscm-app/`

* Username: `administrator`
* Password: `admin123`

As well as to the OpenStack controller:

`http://hostname.fqdn:8880/oscm-app-openstack/`

* Username: `administrator`
* Password: `admin123`

# Start using OSCM
Please refer to our [Getting Started](https://github.com/servicecatalog/development/wiki/Getting-Started) guide.

# Resources
## Docker images and related documentation

* [oscm-core](): Core application
* [oscm-app](): Asynchronous Provisioning Platform (optional)
* [oscm-db](): Database for oscm-core and oscm-app
* [oscm-initdb](): Initializes or restores the database for oscm-core and oscm-app
* [oscm-birt](): Reporting engine (optional)
* [oscm-branding](): Webserver for marketplace branding packages (optional)
* [oscm-proxy](): Reverse proxy for the other containers (optional)

## Source code

* [oscm](https://github.com/servicecatalog/oscm): Application source code for oscm-core and oscm-app
* [oscm-dockerbuild](https://github.com/servicecatalog/oscm-dockerbuild): Docker files and scripts for building the application and Docker images
