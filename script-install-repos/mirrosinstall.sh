#!/bin/bash 

# Cai dat cac goi can thiet
apt-get -y update 
sudo apt-get -y install apache2 apt-mirror

# Tao thu muc chua cac goi cai dat
mkdir /vnptmirror

# Khai bao file 
cp /etc/apt/mirror.list /etc/apt/mirror.list.bak

cat << EOF > /etc/apt/mirror.list

############# config ##################
#
# set base_path /var/spool/apt-mirror

set base_path /vnptmirror

#
# set mirror_path \$base_path/mirror
# set skel_path \$base_path/skel
# set var_path \$base_path/var
# set cleanscript \$var_path/clean.sh
# set defaultarch <running host architecture>
# set postmirror_script \$var_path/postmirror.sh
# set run_postmirror 0
set nthreads 20
set _tilde 0
#
############# end config ##############

deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse

### Danh cho Ubuntu 14.04 32 bit 
deb-i386 http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse

#deb http://archive.ubuntu.com/ubuntu trusty-proposed main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse

deb-src http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu trusty-proposed main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse
clean http://archive.ubuntu.com/ubuntu

EOF

# Tao link toi thu muc chua repos
sudo ln -s /vnptmirror/mirror/archive.ubuntu.com/ubuntu /var/www/html/ubuntu

# Thiet lap crontab

echo "0 2 * * * apt-mirror /usr/bin/apt-mirror > /var/spool/apt-mirror/var/cron.log"  >> /etc/cron.d/apt-mirror
