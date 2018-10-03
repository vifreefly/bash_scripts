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

Before installing Rails, we need to **install database server.** Usually for Rails it's mysql or postgres. Sometimes sqlite uses for development mode.

[databases_install.sh](databases_install.sh) is an automation script with installs MySQL, Postgres, SQlite and MongoDB database servers/clients. To install only Postgres (common shoice for using with Rails), type:

```bash
$ curl -L https://raw.githubusercontent.com/vifreefly/bash_scripts/master/databases_install.sh | bash -s postgres_install
```

Or, because Postgres can be installed actually within a one line, just type instead:

```bash
$ sudo apt install -q -y postgresql postgresql-contrib libpq-dev
```


**Next**, you need to **create Postgres role (user)** with permission to create databases:

1) Login to the postgres system user: `$ sudo -i -u postgres`

2) Login to the psql console: `$ psql`

3) Create user `deploy` with password `123456`:

> It is a good idea to name the postgres user as name of your (Rails) application

```
create role deploy with createdb login password '123456';
```

All done, now you can exit from the psql console and postgres user by typing: `\q` and `exit`.

Additional psql commands:
* Create database `stats` owned by `deploy` role user: `CREATE DATABASE stats OWNER deploy;`
* Delete database `stats`: `DELETE DATABASE stats`

Some Postgres securily manuals:
* https://www.postgresql.org/docs/7.0/static/security.htm
* https://chartio.com/resources/tutorials/how-to-set-the-default-user-password-in-postgresql/
* https://www.digitalocean.com/community/tutorials/how-to-secure-postgresql-against-automated-attacks

## Rails install
Rails required **NodeJS** to compile assets, to install latest LTS release using NVM, type:

```bash
$ curl -L https://raw.githubusercontent.com/vifreefly/bash_scripts/master/languages_install.sh | bash -s node_js_install
```

If you're using background jobs, like Sidekiq, you need to install Redis server for this:

```bash
$ sudo apt install redis-server
```


Now you can install Rails gem itself:

```bash
$ gem install rails
```


## Rails server install + optimization
## Server monitoring, autoupdate from github
