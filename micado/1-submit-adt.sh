#!/bin/sh

settings_file="./_settings"

. $settings_file

read -p "Enter filename (beast_data.xml): " FILE
FILE=${FILE:-beast_data.xml}
read -p "Enter subdirectory (.): " DIR
DIR=${DIR:-.}
read -p "Enter number of parallelisations (1): " SCALE
SCALE=${SCALE:-1}

sed -i "/name: FILE/{n;s/value: .*/value: \"$FILE\"/;}" beast.yaml
sed -i "/name: DIR/{n;s/value: .*/value: \"$DIR\"/;}" beast.yaml
sed -i "s/\&scale .*/\&scale $SCALE/" beast.yaml

echo "Submitting Beast to MiCADO at $MICADO_MASTER with appid \"$APP_ID\"..."
curl --insecure -s -F file=@"beast.yaml" -F id=$APP_ID -X POST -u "$SSL_USER":"$SSL_PASS" https://$MICADO_MASTER:$MICADO_PORT/toscasubmitter/v1.0/app/launch/ | jq