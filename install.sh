#!/bin/bash
set -e

install () {
	echo "Installing Binaries";
	local version=$1;
	local install_dir=$2;
	local binary_url="https://download.docker.com/linux/static/stable/aarch64/docker-${version}.tgz";
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

_version="19.03.5";
_install_path="/usr/local/bin/";
_add_2_docker=false;
_no_sysd=false;

while getopts ':pnd:v:g' opt; do
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
		:)
			echo Expected arguments not given;
			exit 1;
		;;
	esac
done

install "$_version" "$_install_path";
[ "$_no_sysd" = "false" ] && config "$_version" "$_install_path" || true;
[ "$_add_2_docker" != "false" ] && add_2_docker || true;

echo "Done!";

