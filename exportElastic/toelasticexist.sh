#!/bin/bash
cd ./exportElastic/

for date in '01122020' '03122020' '07122020' '08122020' '09122020' '11122020' '13122020' '14122020'; do
  echo $date
  coffee cryptosToElastic.coffee $date > data_elastic.json
  curl -XPUT 192.168.1.136:9200/_bulk -H"Content-Type: application/json" --data-binary @data_elastic.json > ans_$date.log
  rm  data_elastic.json
done
