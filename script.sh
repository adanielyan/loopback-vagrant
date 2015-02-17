#!/usr/bin/env bash
echo "Setting EST timezone..."
sudo ln -sf /usr/share/zoneinfo/EST /etc/localtime
echo "Running apt-get update..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install nfs-common portmap
sudo apt-get install -y mongodb-org git build-essential openssl libssl-dev pkg-config
echo 'Installing g++ for building source code...'
sudo apt-get install g++ make
echo 'Creating nodejs user...'

#sudo su - i 
echo 'Change node configuration'
cd /home/vagrant

cat <<EOF >/home/vagrant/.npmrc
root = /home/vagrant/.local/lib/node_modules
binroot = /home/vagrant/.local/bin
manroot = /home/vagrant/.local/share/man
EOF

mkdir /home/vagrant/.local

NODE_VERSION="0.10.36"
echo "Downloading node v${NODE_VERSION}..."
wget http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz /home/vagrant/
tar xzvf /home/vagrant/node-v${NODE_VERSION}.tar.gz
cd /home/vagrant/node-v${NODE_VERSION}
./configure --prefix=/home/vagrant/.local

echo "Compiling and installing node v${NODE_VERSION}..."
make
make install
ln -s /home/vagrant/.local/lib/node_modules /home/vagrant/.node_modules

echo "Adding aliases and pathes..."
echo "alias ..='cd ..'" >> /home/vagrant/.bashrc
echo "PATH=/home/vagrant/.local/bin:\$PATH" >> /home/vagrant/.bashrc

echo "Removing temp node folders..."
rm -R /home/vagrant/node-v${NODE_VERSION}
rm /home/vagrant/node-v${NODE_VERSION}.tar.gz

echo "The version of nodejs installed is:"
su - vagrant -c '/home/vagrant/.local/bin/node -v'
echo "The version of npm installed is:"
su - vagrant -c '/home/vagrant/.local/bin/npm -v'

sudo chown -R vagrant:vagrant /home/vagrant/
echo "Installing StrongLoop..."
su - vagrant -c '/home/vagrant/.local/bin/npm install -g strongloop'
echo "Installing Bower and Grunt..."
su - vagrant -c '/home/vagrant/.local/bin/npm install -g bower grunt-cli'

echo "Installing unison..."
sudo apt-get install -y unison

echo "Auto-removing packages that are no more required"
sudo apt-get autoremove

mkdir /home/vagrant/.unison

echo "Setting up unison..."
cat <<EOF >/home/vagrant/.unison/default.prf
# Unison preferences file
root = /var/www
root = /home/vagrant/www
auto=true
batch=true
group=false
owner=false
prefer=newer
silent=true
times=true
perms=0
EOF

cd /home/vagrant
echo "Setting up sync job..."
cat <<EOF >/home/vagrant/sync.sh
#!/bin/bash
#
while true; do unison; sleep 1; done;
EOF


sudo mkdir /var/www
sudo chown -R vagrant:vagrant /var/www
sudo chown -R vagrant:vagrant /home/vagrant/


chmod a+rx /home/vagrant/sync.sh
sudo chown -R vagrant:vagrant /home/vagrant/
echo "Writing out current crontab"
sudo crontab -l > mycron
echo "Writing new cron into cron file"
sudo echo "@reboot /home/vagrant/sync.sh" >> tmpcron
echo "Installing new cron file"
crontab -u vagrant tmpcron
sudo rm tmpcron
echo "Please reboot the VM by running vagrant reload on host!"
