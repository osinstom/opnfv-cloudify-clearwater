#!/bin/bash -e

ctx logger debug "${COMMAND}"

release=$(ctx node properties release)

ctx logger info "Configure the APT software source"
if [ ! -f /etc/apt/sources.list.d/clearwater.list ]
  then
    if [ $release = "stable" ]
    then
      echo 'deb http://repo.cw-ngv.com/stable binary/' | sudo tee --append /etc/apt/sources.list.d/clearwater.list
    else
      echo "deb http://repo.cw-ngv.com/archive/$release binary/" | sudo tee --append /etc/apt/sources.list.d/clearwater.list
    fi
    curl -L http://repo.cw-ngv.com/repo_key | sudo apt-key add -
fi
sudo apt-get update

ctx logger info "Installing homestead packages and other clearwater packages"
set +e
sudo DEBIAN_FRONTEND=noninteractive  apt-get -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew install homestead homestead-prov clearwater-prov-tools --yes --force-yes
sudo DEBIAN_FRONTEND=noninteractive  apt-get install clearwater-management --yes --force-yes
set -e
<<<<<<< HEAD
=======
sudo sed -i '47d' /etc/monit/conf.d/clearwater-cassandra.monit
>>>>>>> multi-site
ctx logger info "The installation packages is done correctly"

ctx logger info "Use the DNS server"
echo 'RESOLV_CONF=/etc/dnsmasq.resolv.conf' | sudo tee --append  /etc/default/dnsmasq
sudo service dnsmasq force-reload

ctx logger info "Installation is done"
