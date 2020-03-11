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
* Initialize the application databases
* Start the application containers

```sh
docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true servicecatalog/oscm-deployer
```

# Usage

## Login to the administration portal
The application will take a few minutes to start up. The less CPU power you have, the longer it will take. Once everything has started, you may access the OSCM administration portal in your web browser using the FQDN or IP address you specified earlier.

`https://hostname.fqdn:8081/oscm-portal/`

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

`https://hostname.fqdn:8881/oscm-app/`

* Username: `administrator`
* Password: `admin123`

As well as to the service controllers:

`https://hostname.fqdn:8881/oscm-app-<controller-id>/`

* `<controller-id>`: `azureARM`, `aws`, `openstack`, `vmware`, `shell` 
* Username: `administrator`
* Password: `admin123`

If using SSL you can configure your own users in the var.env file. You can set therefore the ADMIN_USER_ID, SUPPLIER_USER_ID, CUSTOMER_USER_ID and CONTROLLER_USER_NAME

# Import custom SSL certificates and key files
Certificates are required to allow for trusted communication between OSCM and the Asynchronous Provisioning Platform (APP), or an application underlying a technical service. The OSCM deployer has already created a respective directory structure and a suitable Docker Compose configuration. In this way, default certificates have been inserted into the respective containers after deployment, thus communication between OSCM and APP is secured. 

It is, however, possible to use custom SSL keypairs for the application listeners. They may be self-signed or official. Privacy Enhanced Mail (PEM) format is mandatory. This is a container format that may include just the public certificate, or an entire certificate chain including public key, private key, and root certificates. It is only necessary to place the respective certificate and/or key files in PEM format into the appropriate directories.

## Import SSL keypairs for the application listeners
If you want to use your own SSL key pairs that your application is to use, replace the default key pair by your PEM files in the following directories on your Docker host: 

* Private key: `/docker/config/<CONTAINER_NAME>/ssl/privkey`
* Public certificate: `/docker/config/<CONTAINER_NAME>/ssl/cert`
* Intermediates / chain (optional): `/docker/config/<CONTAINER_NAME>/ssl/chain`

Note:

Replace `/docker` with the directory where Docker is installed, and `<CONTAINER_NAME>` with the respective container name, e.g. `oscm-core`.

The custom certificates must also be placed into the trusted directory so that a trusted relationship between the containers is established: 

* `/docker/config/certs`

This directory is shared by all containers. By default, if you use your own SSL key pairs, you must also place all the public certificate files here.

For example, if you have a custom SSL keypair for the `oscm-core` container, you need to place the private key into the `/docker/config/oscm-core/ssl/privkey` directory, and the public certificate into the `/docker/config/oscm-core/ssl/cert` directory. Additionally, you need to place the public certificate into the `/docker/config/certs` directory on your Docker host. In this case, a restart of the `oscm-core` and `oscm-app` containers is required.

## Import trusted SSL certificates
If you want your application to trust certain, possibly self-signed, SSL certificates, put them in PEM format in the following directory on your Docker host: 

* `/docker/config/certs`

<!-- ## Import exteral IDPs' certificates
In SAML_SP authentication mode where you can configure external idp to manage oscm authentication, you have to put the idp's certificate used to sign SAML messages in the following directory on your Docker host: 

* `/docker/config/certs/sso`

Note:

Replace `/docker` with the directory where Docker is installed. 

For example, if you want to use the VMware service controller, you need to export the vSphere certificate in PEM format, and copy it to the `/docker/config/certs` directory.  Since the VMware service controller is running in the `oscm-app` container, a restart of this container is required. -->

# Import scripts for the Shell controller (oscm-app-shell)
Using the Shell integration software, you can execute your own shell scripts when managing subscriptions.

Such scripts can be specified in marketable service parameters, and then referenced as a script located either inside or outside (e.g. external URL) the docker host. 

To reference a script located inside the docker host:

* Put it into the `/docker/config/oscm-app/scripts` directory on your docker host
* Define a proper service parameter. It may only include the script filename (without any path specified e.g. sample.sh)
* Restart the oscm-app container

# Start using OSCM
Please refer to our [Getting Started](https://github.com/servicecatalog/oscm/wiki/Getting-Started) guide.

# Resources

## Docker images and related documentation
* [oscm-deployer](https://hub.docker.com/r/servicecatalog/oscm-deployer): Application for deploying OSCM
* [oscm-core](https://hub.docker.com/r/servicecatalog/oscm-core/): Core application
* [oscm-help](https://hub.docker.com/r/servicecatalog/oscm-help): Online-help for the OSCM Portal
* [oscm-app](https://hub.docker.com/r/servicecatalog/oscm-app): Asynchronous Provisioning Platform (optional)
* [oscm-db](https://hub.docker.com/r/servicecatalog/oscm-db): Database for oscm-core and oscm-app
* [oscm-initdb](https://hub.docker.com/r/servicecatalog/oscm-initdb): Initializes or restores the databases for oscm-core and oscm-app
* [oscm-birt](https://hub.docker.com/r/servicecatalog/oscm-birt): Reporting engine (optional)
* [oscm-branding](https://hub.docker.com/r/servicecatalog/oscm-branding): Webserver for marketplace branding packages (optional)
* [oscm-identity](https://hub.docker.com/r/servicecatalog/oscm-identity): OSCM Identity Service (optional)
* [oscm-maildev](https://hub.docker.com/r/servicecatalog/oscm-maildev): Mail Service Mock (optional)
## Source code

* [oscm](https://github.com/servicecatalog/oscm): Application source code for oscm-core and oscm-app
* [oscm-dockerbuild](https://github.com/servicecatalog/oscm-dockerbuild): Docker files and scripts for building the application and Docker images
