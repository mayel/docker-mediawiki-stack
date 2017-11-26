#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


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
GetCert -d wiki.haha.academy -d haha.academy
GetCert -d wiki.social.coop

echo "Restarting Web Frontend..."
docker stop dockermediawikistack_nginx_1
docker start dockermediawikistack_nginx_1

echo "Done"
