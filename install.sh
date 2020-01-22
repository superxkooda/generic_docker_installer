#!/bin/bash
set -e

install () {
	echo "Installing Binaries";
	local version=$1;
	local install_dir=$2;
	local arch=$3
	local binary_url="https://download.docker.com/linux/static/stable/${arch}/docker-${version}.tgz";
	curl -s ${binary_url} | sudo tar xvz --strip-components=1 -C ${install_dir};
	grep -q docker /etc/group || sudo groupadd docker
	
}

config () {
	echo "Configuring systemd.";
	local version=$(awk 'BEGIN{FS="."}{print $1"."$2}' <<<"${1}");
	local install_dir="$(sed 's/\//\\\//g'<<<${2})";
	local git_url="https://raw.githubusercontent.com/docker/docker-ce/${version}/components/engine/contrib/init/systemd/docker";
	curl -s ${git_url}.service | sed "s/\/usr\/bin\//${install_dir}/" | sudo tee /etc/systemd/system/docker.service >/dev/null;
	curl -s ${git_url}.socket | sudo tee /etc/systemd/system/docker.socket >/dev/null;
}

add_2_docker () {
	echo "Adding your curret account to the docker group";
	user=$(whoami);
	grep -q "docker" <<<$(groups ${user}) && \
		echo "${user} already in docker group. Nothing to do here :)" || \
		sudo usermod -a -G docker ${user};
}

_help () {
	local default_version=$1;
	local default_path=$2;
	local default_arch=$3;
	cat << EOF
GENERIC DOCKER INSTALLER

This shell script will install Docker via the available pre compiled binaries available
on their site. All the binaries are downloaded from https://download.docker.com/linux/static/stable/.
The systemd configs are grabbed from the appropriate version off of their github
https://github.com/docker/docker-ce

-v	What version to install, default value = ${default_verison}
	usage: -v ${default_version}
	available versions can be found here https://download.docker.com/linux/static/stable/.

-p	Install path, default value = ${default_path}.
	usage: -p ${default_path}

-a	Set the targeted architecture, default value = ${default_arch}.
	Possible ones to choose from at this time are aarch64, armel, armhf, ppc64le, s390x, and x86_64.
	usage: -a ${default_arch}

-n	If set this script won't set a systemd configs /etc/systemd/system/{docker,docker.socket}

-g	Will add your current user to the docker group if not already in it.

EOF
	exit 0;
}

_version="19.03.5";
_install_path="/usr/local/bin/";
_add_2_docker=false;
_no_sysd=false;
_arch="aarch64";

while getopts ':pnd:v:a:gh' opt; do
	case $opt in
		p)
			_install_path="${OPTARG}";
		;;
		n)
			_no_sysd=true;
		;;
		g)
			_add_2_docker=true;
		;;
		v)
			_version="${OPTARG}";
		;;
		a)
			_aarch="${OPTARG}";
		;;
		h)
			_help "${_version}" "${_install_path}" "${_arch}";
		;;
		:)
			echo Expected arguments not given;
			exit 1;
		;;
	esac
done

install "$_version" "$_install_path" "$_arch";
[ "$_no_sysd" = "false" ] && config "$_version" "$_install_path" || true;
[ "$_add_2_docker" != "false" ] && add_2_docker || true;

echo "Done!";

