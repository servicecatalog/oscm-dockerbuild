# Quick start OSCM with Docker
This is a quick start guide intended to help you start up a basic installation of [Open Service Catalog Manager (OSCM)](https://openservicecatalogmanager.org/) with Docker and Docker Compose as quickly as possible. For more advanced configuration and usage please refer to the individual Docker containers' documentation. You can find the links in the [Resources](#resources) section.

# Prerequisites
A Linux system with:

* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

We will refer to the Linux system with Docker installed as the *docker host*.

For initial tests, we recommend:

* 2 CPU cores
* 8GB of RAM
* 20GB of disk space

Please note that this minimum configuration is not suitable for production use.

# Setup

## Prepare directory on the host
We require a directory on the docker host which holds various data such as persistent database data, configuration data and so on. We will use `/docker` as an example, please substitute your own directory path.

```sh
mkdir /docker
```

## Prepare configuration files
We will run a deployment container which prepares configuration file templates for us. Use `-v` to mount the directory you created earlier to /target in the container.

```sh
docker run --name deployer1 --rm -v /docker:/target servicecatalog/oscm-deployer
```

This creates two files with configuration variables. Please edit both files and adjust the configuration to your environment.

* .env: Configuration for Docker, such as images and the base data directory
* var.env: Configuration for the application, such as mail server, database and other settings

## Prepare Docker Compose files and start the application
We will run a second deployment container which does the following:

* Create the necessary Docker Compose files
* Create the necessary subdirectories
* Initialize the application database
* Start the application containers

```sh
docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true servicecatalog/oscm-deployer
```

# Usage

## Login to the administration portal
The application will take a few minutes to start up. The less CPU power you have, the longer it will take. Once everything has started, you may access the OSCM administration portal in your web browser using the FQDN or IP address you specified earlier.

`http://hostname.fqdn:8080/oscm-portal/`

The initial login credentials are:

* Username: `administrator`
* Password: `admin123`

## Enable login to APP and controllers
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
Please refer to our [Getting Started](https://github.com/servicecatalog/oscm/wiki/Getting-Started) guide.

# Resources

## Docker images and related documentation

* [oscm-core](https://hub.docker.com/r/servicecatalog/oscm-core/): Core application
* [oscm-app](https://hub.docker.com/r/servicecatalog/oscm-app): Asynchronous Provisioning Platform (optional)
* [oscm-db](https://hub.docker.com/r/servicecatalog/oscm-db): Database for oscm-core and oscm-app
* [oscm-initdb](https://hub.docker.com/r/servicecatalog/oscm-initdb): Initializes or restores the database for oscm-core and oscm-app
* [oscm-birt](https://hub.docker.com/r/servicecatalog/oscm-birt): Reporting engine (optional)
* [oscm-branding](https://hub.docker.com/r/servicecatalog/oscm-branding): Webserver for marketplace branding packages (optional)
* [oscm-proxy](https://hub.docker.com/r/servicecatalog/oscm-proxy): Reverse proxy for the other containers (optional)

## Source code

* [oscm](https://github.com/servicecatalog/oscm): Application source code for oscm-core and oscm-app
* [oscm-dockerbuild](https://github.com/servicecatalog/oscm-dockerbuild): Docker files and scripts for building the application and Docker images
