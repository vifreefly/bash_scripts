# Ruby/Rails setup readme

## Basic ubuntu 16.04 setup

First, you need to perform a basic setup: [_Ubuntu server setup readme_](https://github.com/vifreefly/bash_scripts/blob/master/README.md).


## Ruby setup

After when you done with a basic setup, we are going to install ruby.

Here is a script: [languages_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/languages_install.sh).

> Script contains setup for python, go, nodejs and ruby programming languages. You can install only one language, for this just provide a name of the function to execute, in our case (ruby) it will be: `$ bash languages_install.sh ruby_install`.

For ruby setup script doing next things:
1. Install ruby compilation dependencies
2. Install rbenv
3. Install latest ruby version (2.5.1) using rbenv and makes it default
4. Install bundler gem

To install:
```bash
$ curl -L https://raw.githubusercontent.com/vifreefly/bash_scripts/master/languages_install.sh | bash -s ruby_install
```

After, update enviroment variables of your bash session (to have a just installed rbenv/ruby command avaiable in terminal): `$ exec $SHELL`.


## Database install

Before installing Rails, we need to install database server. Usually for Rails it's mysql or postgres. Sometimes sqlite uses for development mode.

So, _we need_ to install **sqlite** support **+** **mysql** or **postgres** server **and setup a database user**. Check the [DATABASES_SETUP.md](https://github.com/vifreefly/bash_scripts/blob/master/base_install.sh) guide how to do it.

## Rails install
> Install nodeJS

## Rails server install + optimization

## Server monitoring, autoupdate from github
