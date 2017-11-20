#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

find $DIR/distribution-files/mwcore/mediawiki -type d -exec chmod 755 {} +
find $DIR/distribution-files/mwcore/mediawiki -type f -exec chmod 644 {} +
chown -R www-data $DIR/distribution-files/mwcore/mediawiki
chgrp -R www-data $DIR/distribution-files/mwcore/mediawiki
