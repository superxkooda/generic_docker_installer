# GENERIC DOCKER INSTALLER

This shell script will install Docker via the available pre compiled binaries available 
on their site. All the binaries are downloaded from https://download.docker.com/linux/static/stable/.
The systemd configs are grabbed from the appropriate version off of their github 
https://github.com/docker/docker-ce

```
-v	What version to install, default value = 
       usage: -v 19.03.5
       available versions can be found here https://download.docker.com/linux/static/stable/.

-p	Install path, default value = /usr/local/bin/.
       usage: -p /usr/local/bin/

-a	Set the targeted architecture, default value = aarch64.
       Possible ones to choose from at this time are aarch64, armel, armhf, ppc64le, s390x, and x86_64.
       usage: -a aarch64

-n	If set this script won't set a systemd configs /etc/systemd/system/{docker,docker.socket}

-g	Will add your current user to the docker group if not already in it.
```
After the install you may want to consider enabling docker for boot with `systemctl enable docker`.
