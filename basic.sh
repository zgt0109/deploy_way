#!/bin/bash

# initialize
GEM_SOURCES_CHINA=https://gems.ruby-china.org/
GEM_SOURCES_ORIGIN=https://rubygems.org/

# rsa_pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXqqura67hScy6V+A2r2YEUQXHZiwkFCR/4TLZGHNufYC+0j+2tZC4nTwjCCGrBIVLuE2ZEbvAItUt8XTKVLe+8vzT/oHsnopxCTEwe1bXOj+XeC9PAGZx5tQG9WKps9XqBovV6dw5NfOpjjEEKoTXCIZxlOqL9d94pEDM9hGvc/So1GtOiLEJSwNV19wIdQjTi3fyUhRhRey85usDon1blWilSPpUJQi2FMWhRoQn74DTiHOyR2P/y9sWN8uL/91wxOuxAiiCp1XsrPPNntZk8fTibkiW4pOxiwfI3HBX0XmAPOgDU3aR44qHw0dqQ4Z0CNj9payKUkWiS0sPickh zgt@zgt-Lenovo-Y430P"

secret_key="c6cf1a911977bd40ffef2a3cee6d062703e0322ef4885534694a50f9c704e2aefa\
8af3c4ed4d4a1fe5900101895da6b54973c7f8490821ded451b28a5305e526"

read -p "Public Key? " rsa_pub
read -p "Deploy User Name? " user_name
read -p "Application Name? " app_name


# user
CHECK_USER=$(grep $user_name /etc/passwd | wc -l)

if [ ! $CHECK_USER -ge 1 ]; then
  useradd -m -G sudo,adm -s /bin/bash $user_name
  echo "${user_name} ALL=NOPASSWD:ALL" >> /etc/sudoers
su - $user_name  <<EOF
# bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}
# SSH
mkdir ~/.ssh
echo ${rsa_pub} >> ~/.ssh/authorized_keys
sed  -i "1i # Rails Applicaton Configure\n" ~/.bashrc
sed  -i "1a export RAILS_ENV=production" ~/.bashrc
sed  -i "1a export SECRET_KEY_BASE=${secret_key}" ~/.bashrc
EOF
fi
# app
app_path=/var/www/$app_name
if [ ! -d $app_path ]; then
mkdir -p $app_path
chown -R $user_name:$user_name $app_path

fi

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "