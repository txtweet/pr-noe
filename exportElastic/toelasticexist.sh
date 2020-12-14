#!/bin/bash


for date in '01122020' '03122020' '07122020' '08122020' '0912020' '11122020' '13122020' '1412020' '30112020'; do
  echo $date
  coffee ./cryptosToElastic.coffee $date > data_elastic_$date.json
  curl -XPUT localhost:9200/_bulk -H"Content-Type: application/json" --data-binary @data_elastic.json
  rm data_elastic.json
done
