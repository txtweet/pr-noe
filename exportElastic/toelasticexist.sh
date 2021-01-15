#!/bin/bash

source ./elastic.creds
ad='localhost:9100'

array=(`cat ./done.lst`)

for file in ../cryptos-*.json ; do
  set `echo "$file"|cut -d '-' -f 2|cut -d '.' -f 1` # Remove - and . from file
  value=$*
  if [[ ! " ${array[@]} " =~ " ${value} " ]]; then
    coffee cryptosToElastic.coffee $* > data_elastic_$*.json
    echo "$*" >> done.lst
    echo "Commande à passer sur elastic : "
    echo "curl -u $user:$passwd -sS -XPUT $ad/_bulk -H'Content-Type: application/json' --data-binary @data_elastic_$*.json|json"
    echo "rm data_elastic_$*.json"
  fi
done
