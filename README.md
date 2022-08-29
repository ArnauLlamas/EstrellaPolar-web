# Terraform Skeleton

Repository to use as quick entrypoint to start developing new Terraform repositories.

Main purpose of this skeleton is to keep repositories DRY (Don't Repeat Yourself) and to provide a development environment for easy development of Terraform repositories.

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Make](https://www.gnu.org/software/make/)

## How to use the Skeleton

Any interaction with repositories created from this skeleton (aside from writing Terraform code) should be done from the Makefile. Take a minute to look at it, feel free to modify it for your specific needs of your project and keep it up to date as if Terraform code was. Additionally, to avoid inconsistencies with `.terraform.lock.hcl` files, execute all Terraform commands inside the provided container. You can quickly access it executing the command `make start` in the root folder of the project.

All Terraform code is handled in the `terraform` directory. Inside, you can create both compositions (combination of environment and region) in the `environment` directory or create custom local modules in the `modules` directory. Inside the `environments` folder there is a `shared` directory. Use this folder to instantiate any resource or module that has to be created in all compositions. Other folders in the `environments` directory contain specific compositions. As Terraform does not provide an **include** parameter, instantiations of the shared directory are linked via **symlinks**, remember to create pertinent symlinks if you create any file in the shared folder or modify any of the existing's name.

Inside any specific composition you can create any new file for instantiating resources that only exists in that composition or you can use the [**override**](https://www.terraform.io/language/files/override) feature to modify the shared files only for that composition. Note that you cannot override the `provider` block.

## Development

Fill the environment file:
* `./.env` contains details of the project and AWS credentials, is used by the `docker-compose.yml` file and the development container

An example file is provided to help you out filling the environment file correctly.

This project is provided along with a development container that will include all necessary technologies to start developing comfortably along with a handy Makefile provided to avoid repetitive tasks.

To start the development container and create a tty on it:

```
make start
```

Once inside the development container, you can make use of the Makefile to shorten typical Terraform commands, check the Makefile documentation to find them.

```
make help
```

Retrieve all states by executing

```
make init-all
```

You can execute linter globally or per composition to detect errors that Terraform plans do not

```
make lint-all
make lint-testing
```

You can also execute a Security/Good practices checker globally or per composition
(TFSec is not prepared to work with AWS provider version bigger or equal than 4.0.0 at the moment of writing this, you might encounter unexpected or false positives if you use the following commands, especially on S3 resources. GitHub issue: https://github.com/aquasecurity/tfsec/issues/1532)

```
make sec-all
make sec-testing
```

Finally, do not forget to execute a test plan before pushing any changes! You can do this quickly by executing

```
make test
```

This action executes, in order
* A format checker
* A terraform validate per composition
* A lint execution per composition
* A plan execution per composition
