#!/bin/bash
cd ./exportElastic/

if [ -z $1 ]
then
  date=$(date +'%d%m%Y')
  echo "Using today date : $date"
else
  date=$1
  echo "Using provided date : $date"
fi
coffee cryptosToElastic.coffee $date > data_elastic_$date.json
curl -XPUT 192.168.1.136:9200/_bulk -H"Content-Type: application/json" --data-binary @data_elastic_$date.json > ans_$date.log