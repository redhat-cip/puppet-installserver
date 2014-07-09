#!/bin/bash
#
#  Deploy a SpinalStack Install Server Quickly
#

ORIG=$(cd $(dirname $0); pwd)
if [ -d /vagrant ]; then
	ORIG="/vagrant"
fi

if [ -f /etc/redhat-release ]; then
	OS=redhat
elif [ -f /etc/lsb-release ]; then
	OS=ubuntu
elif [ -f /etc/debian_version ]; then
	OS=debian
else
	echo "Error - OS unknown"
	exit 1
fi

case "$OS" in
    "redhat")
	yum update
	yum install puppet rubygems git
	gem install r10k
	cd $ORIG
	r10k puppetfile install
        ;;
    "ubuntu")
	apt-get update
        apt-get -y install puppet rubygems git
	gem install r10k
	cd $ORIG
	r10k puppetfile install
        ;;
    "debian")
	wget https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
	dpkg -i puppetlabs-release-wheezy.deb
	apt-get update
	apt-get -y --force-yes install puppet rubygems git tzdata=2014a-0wheezy1
	gem install r10k
	cd $ORIG
	r10k puppetfile install
	echo "127.0.0.1 `facter fqdn`" >> /etc/hosts	
	;;
    *)
        exit 0
        ;; 
esac

puppet apply --modulepath=$ORIG/modules $ORIG/install-server.pp
