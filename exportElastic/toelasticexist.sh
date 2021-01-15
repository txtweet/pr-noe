#!/bin/bash

source ./elastic.creds
ad='localhost:9100'

for file in ../cryptos-*.json ; do
  set `echo "$file"|cut -d '-' -f 2|cut -d '.' -f 1` # Remove - and . from file
  echo "$*"
  coffee cryptosToElastic.coffee $* > data_elastic_$*.json
#   # curl -XPUT $ad/_bulk -H"Content-Type: application/json" --data-binary @data_elastic_$date.json > ans_$date.log
#   #rm  data_elastic.json
done
