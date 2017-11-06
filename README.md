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

This creates two files.

* .env: Configuration for Docker, such as images and the data directory
* var.env: Configuration for the application, such as mail server, database and other settings

## Prepare Docker Compose files and start the application
If you are using a different data directory, please change `DOCKER_PATH` in the file `.env` accordingly.

Please edit the file `var.env` and adjust the following configuration settings:

* SMTP_HOST: The host name or IP address of your mail server
* SMTP_PORT: The port of your mail server
* SMTP_FROM: The sender email address that OSCM should use
* SMTP_USER: The user name for your mail server if it requires authentication; if no authentication is required, please set `none`
* SMTP_PWD: The password for your mail server if it requires authentication; if no authentication is required, please set `none`
* SMTP_AUTH: Whether your mail server requires authentication; can be `true` or `false`
* SMTP_TLS: Whether to use TLS for mail server communication; can be `true` or `false`
* KEY_SECRET: A secret string which will be used as a seed for encryption in the database. Please do not lose this if you plan to keep your database.
* HOST_FQDN: The host name or IP address which you will use to access the application
* REPORT_ENGINEURL: Replace `${HOST_FQDN}` with the same value as above; please leave the other placeholders intact
* DB_PORT_*: The port of the PostgreSQL database; `5432`
* DB_PWD_* and DB_SUPERPWD: Passwords for the databases and the database super user
* APP_ADMIN_MAIL_ADDRESS: The sender email address that the Asynchronous Provisioning Platform (APP) should use
* CONTROLLER_ORG_ID: Set to `PLATFORM_OPERATOR`
* CONTROLLER_USER_KEY: Set to `1000`
* CONTROLLER_USER_NAME: Set to `administrator`
* CONTROLLER_USER_PASS: Set to `admin123`
* TOMEE_DEBUG: Set to `false` unless you need debug logs

We will run a second deployment container which does the following:

* Create the necessary Docker Compose files
* Create the necessary subdirectories
* Initialize the application database
* Start the application containers

```sh
docker run --name deployer2 --rm -v /docker:/target -v /var/run/docker.sock:/var/run/docker.sock -e INITDB=true -e STARTUP=true servicecatalog/oscm-deployer
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

* [development](https://github.com/servicecatalog/development): Application source code for oscm-core and oscm-app
* [oscm-dockerbuild](https://github.com/servicecatalog/oscm-dockerbuild): Docker files and scripts for building the application and Docker images
