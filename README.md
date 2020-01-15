# Install docker on Pinebook Pro 
A quick search did not yeld any results on a painless way to install docker so here is a quick utility to do so.
This was written to work with the version of Debian that ships with the Pinebook Pro, though there should be no
reason for it not to work on other flavors. This is not debian specific and it will set up systemd unless -n 
option is passed. You must have sudo privileges to run this.

## Options 
- -i : install path, defaults to /usr/local/bin
- -g : auto add your current user account to the docker user group
- -v : targeted docker version, defaults to 19.03.5
- -n : skip setting up systemd

## Example
./install.sh -i /usr/bin -g

## Once Finished
- If -g was used be sure to log out and in in order for the changes to take effect.
- `systemctl enable docker` to start docker at boot.
- Add any other accounts you wish to have access to docker.
