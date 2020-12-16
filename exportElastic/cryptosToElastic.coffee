_ = require 'lodash'
unless process.argv[2]?
  console.warn("usage : coffee cryptosToElastic.coffee <date>")
  process.exit(1)

date = process.argv[2]
raw = require '../cryptos-'+date+'.json'
datas = require '../cryptos.json'

ret=''

for crypto in raw.data
  if datas[crypto.name]?
    datadb={}
    _.forEach(datas[crypto.name], (val, key) ->
      unless key == "name" or key == "tags" or key == "forked_data" or key=="depends" or key== "people" or key=="deaths"
        datadb[key]=val
        return
      if key == "tags"
        val.forEach((x) ->
          datadb["tag_"+x] = true
        )
        return
      if key == "depends"
        val.forEach((x) ->
          datadb["depends_"+x] = true
        )
        return
      if key == "people"
        val.forEach((x) ->
          datadb["people_"+x] = true
        )
        return
      if key == "deaths"
        val.forEach((x) -> 
          datadb["deaths_"+x] = true
        )
        return
      if key == "forked_data"
        if val["block"]?
          datadb["forked_block"]=val["block"][0]
          if val["block"].length > 1
            val["block"].splice(0,1)
            for  block, index in val["block"]
              datadb["forked_block_"+(index+1)]=block

        if val["forked_from"]?
          val["forked_from"].forEach( (x) ->
            datadb["foked_from_"+x]=true
          )
    )
  else
    console.warn("#{crypto.name} not found in DB")

  tags = crypto.tags.map( (x) -> return "\"tag_api_#{x}\":true" )
  ret+="""{"index":{"_index": "cryptos"}}\n"""
  ret+="{\"id_coincap\": #{crypto.id},
  \"name\":\"#{crypto.name}\",
  \"symbol\":\"#{crypto.symbol}\",
  \"slug\":\"#{crypto.slug}\","
  if tags.length > 0
    ret+="#{tags},"
  ret+="\"date_data\": \"#{raw.status.timestamp}\",
  \"max_supply\":#{crypto.max_supply},
  \"circulating_supply\":#{crypto.circulating_supply},
  \"total_supply\": #{crypto.total_supply},
  \"last_updated\": \"#{crypto.last_updated}\",
  \"price\": #{crypto.quote.USD.price},
  \"volume_24h\": #{crypto.quote.USD.volume_24h},
  \"percent_change_1h\": #{crypto.quote.USD.percent_change_1h},
  \"percent_change_24h\":#{crypto.quote.USD.percent_change_24h},
  \"percent_change_7d\": #{crypto.quote.USD.percent_change_7d},
  \"market_cap\": #{crypto.quote.USD.market_cap},
  \"usd_last_updated\": \"#{crypto.quote.USD.last_updated}\""
  block = crypto.tags.map( (x) -> return "\"tag_api_#{x}\":true" )
  _.forEach(datadb, (val,key) ->
    unless val == true or val== false
      val="\"#{val}\""
    ret+=",\"#{key}\":#{val}"
  )
  ret+="}\n"

console.log(ret)