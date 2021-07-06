#!/bin/bash

# library dependencies
apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    gnupg2 \
    libpq-dev \
    curl \
    sudo \
    patch \
    gawk \
    g++ \
    gcc \
    autoconf \
    automake \
    bison \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libtool \
    libyaml-dev \
    make \
    patch \
    pkg-config \
    sqlite3 \
    zlib1g-dev \
    libgmp-dev \
    libreadline-dev \
    libssl-dev \
    nodejs \
    npm \
&& apt clean

# services and miscellaneous
apt-get install --no-install-recommends -y \
    postgresql-contrib \
    nano \
    tmux \
&& apt clean

npm install -g yarn

# install nginx and passenger
# see https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/bionic/install_passenger.html
source /etc/os-release
apt-get install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates
echo deb https://oss-binaries.phusionpassenger.com/apt/passenger $UBUNTU_CODENAME main > /etc/apt/sources.list.d/passenger.list
apt-get update
apt-get install -y nginx libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
ls /etc/nginx/conf.d/mod-http-passenger.conf
service nginx restart
/usr/sbin/passenger-memory-stats

# setup deploy user
DEPLOY_USER="deploy"

useradd --create-home --shell /bin/bash $DEPLOY_USER

cp -r ~/.ssh /home/$DEPLOY_USER/
chown -R $DEPLOY_USER: /home/$DEPLOY_USER/.ssh
echo "$DEPLOY_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install some user specific dependencies

sudo -i -u $DEPLOY_USER bash << EOF
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /home/$DEPLOY_USER/.rvm/scripts/rvm
rvm install 3.0
rvm use 3.0 --default
gem install bundler:2.2.17
EOF

DOMAIN="example.com"

cat << EOF >> /etc/nginx/sites-enabled/app.conf
server {
    listen 80;
    server_name $DOMAIN;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /home/deploy/app/current/public;

    # Turn on Passenger
    passenger_enabled on;
    passenger_ruby /home/$DEPLOY_USER/.rvm/gems/ruby-3.0.0/wrappers/ruby;
}
EOF
service nginx restart
