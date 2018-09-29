# Ubuntu server setup readme

## Installation for ubuntu server

* Also check this awesome article [Initial Server Setup with Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04)

First, login to the server as a root user: `$ ssh root@your_server_ip`. You'll be asked for a password, so fill in it (usually vps provider sent password for VPS root user to email right after when server was created, or, you can find it in VPS dashboard).

### Create a new sudo user

```bash
# create user `username`:
$ adduser username

# add `username` to the sudo group:
$ adduser username sudo # or `$ gpasswd -a username sudo`
```
Then logout and login again to the server using your `username` login.


### Setup ssh keys, copy your public key to the server
> You can totally skip this part if you created your server without ssh key authorization, and you are okay with entering password each time when you want to login to the server.

If you want to login to the server automatically (just ssh `username@your_server_ip`, without password prompt), your need to setup ssh keys.

> Note: if when you created server you decided to authorize using ssh key and provided a public key, then you probably already have a pair of public/private keys on your desktop.
> You already can authorize on server within `root` user without password. But, we just created an another sudo user (as you know it's not a good idea to use `root` for any setup on the server), and this new user don't have your public key (as root user has) in it's `~/.ssh/authorized_keys`.
> So just add public key to this user `$ ssh-copy-id -i ~/.ssh/id_rsa.pub "username@your_server_ip -p 22"` and you can skip the part below.

#### On your desktop  (not server)
First, you need to have a pair of private/public ssh key. Check maybe it's there already: `$ ls ~/.ssh` - if in listed files you see `id_rsa` and `id_rsa.pub` then all is fine.

In case if don't, or you want to use different ssh key pair, not default one, generate it using `ssh-keygen` tool:

```bash
$ ssh-keygen
```
`ssh-keygen` will ask you to pick a name for a keypair, and optional passprase.


**Next:**
Invoke ssh-agent keychain firt, in case if it not loaded yet
```bash
$ eval $(ssh-agent)
```

`ssh-add`  command will load your private id_rsa key to the system keychain, so you can login to the servers without password if these servers have matching public key (`id_rsa.pub`) with this private key.
Usually linux automatically loads private key with a name `id_rsa` to the keychain,so this option only to show how you can load a custom one (with name other than `id_rsa`) private key to the keychain using `ssh-add` tool.

```bash
$ ssh-add ~/.ssh/id_rsa
```

`ssh-copy-id` command will copy to the server a public key (`id_rsa.pub`) of your private key (`id_rsa`).
All public keys added within tool `ssh-copy-id` are stored on remote machine in the file `~/.ssh/authorized_keys`.

```bash
$ ssh-copy-id -i ~/.ssh/id_rsa.pub "username@your_server_ip -p 22"
```


**SSH keys setup is done.**
Try again to login to the server `$ username@your_server_ip` and you should't see any password prompt.

Don't lost your `id_rsa` private key, becase then you'll can't login to `$ username@your_server_ip` using ssh key, only within user's password.

Also there is an additional setup to restrict login to root user using password (and allow login only with ssh key) to prevent possible bruteforce attacks. But we'll skip this part for now, and, probably it's already enabled in `/etc/ssh/sshd_config`.


### Server installation scripts
> All interactions should be done within sudo user created above, not `root` user.
> All installations splitted into several bash scripts, which doing all setup for you.
> After execution of each script, you need to update env variables of you current bash session: `$ exec $SHELL`

**Install basic utils**:
First we'll install some command line tools, some of them are required for next setup, but some of them just handy to use in day to day server administration process.

You can check the script here [base_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/base_install.sh):

Installation:
```bash
$ curl -L https://raw.githubusercontent.com/vifreefly/bash_scripts/master/base_install.sh | bash
```

For now, basic setup for an ubuntu server is done. You can check other avaiable automation scripts:
* [languages_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/languages_install.sh)
* [databases_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/databases_install.sh)
* [headless_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/headless_install.sh)
* [cli_utils_install.sh](https://github.com/vifreefly/bash_scripts/blob/master/cli_utils_install.sh)
