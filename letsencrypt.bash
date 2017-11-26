#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo "Restarting frontend to prepare to serve .well-known"
docker-compose down
docker-compose up -d
sleep 20


echo "Preparing certbot"
docker pull palobo/certbot

GetCert() {
  docker run -it \
    --rm \
    -v $DIR/letsencrypt/etc:/etc/letsencrypt \
    -v $DIR/letsencrypt/lib:/var/lib/letsencrypt \
    -v $DIR/letsencrypt/www:/var/www/.well-known \
    palobo/certbot -t certonly --webroot -w /var/www \
    --keep-until-expiring \
    $@
}

echo "Getting certificates..."
# customise with your domain(s) here
GetCert -d wiki.haha.academy
GetCert -d wiki.social.coop

echo "Restarting Web Frontend..."
cd $DIR
docker-compose down
docker-compose up -d

echo "Done"
