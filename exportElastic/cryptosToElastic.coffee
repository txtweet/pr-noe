_ = require 'lodash'
unless process.argv[2]?
  console.warn("usage : coffee cryptosToElastic.coffee <date>")
  process.exit(1)

date = process.argv[2]
raw = require '../cryptos-'+date+'.json'
datas = require '../cryptos.json'

ret=''
chains = ['EOS', 'Binance', 'Solana', 'Huobi ECO',
'Codex', 'KnoxFS', 'KLAYswap Protocol', 'e-Money',
'Tron', 'AI', 'Waves', 'Beacon','Fuse']

for crypto in raw.data
  found = datas[crypto.name]
  unless found?
    found = _.find (_.values datas), {"url": "/currencies/#{crypto.slug}"}

  unless found?
    console.warn("#{crypto.name} not found in DB")
  else
    unless "Dead" in found.tags
      datadb={}
      _.forEach datas[crypto.name], (val, key) ->
        unless key == "name" or key == "tags" or key == "forked_data" or key=="depends" or key== "people" or key=="deaths"
          datadb[key]=val
        if key == "tags"
          val.forEach (x) ->

            if not x.endsWith('L') or
            x is not 'NoLicenceFile' or
            x is not 'NoGitHub'
              datadb["tag_"+x] = true

            if x in chains
              datadb["tag_Other Contract"] = true

        # if key == "depends"
        #   val.forEach((x) ->
        #     datadb["depends_"+x] = true
        #   )
        # if key == "people"
        #   val.forEach((x) ->
        #     datadb["people_"+x] = true
        #   )
        # if key == "deaths"
        #   val.forEach((x) ->
        #     datadb["deaths_"+x] = true
        #   )
        # if key == "forked_data"
        #   if val["block"]?
        #     datadb["forked_block"]=val["block"][0]
        #     if val["block"].length > 1
        #       val["block"].splice(0,1)
        #       for  block, index in val["block"]
        #         datadb["forked_block_"+(index+1)]=block
        #
        #   if val["forked_from"]?
        #     val["forked_from"].forEach( (x) ->
        #       datadb["foked_from_"+x]=true
        #     )

      tags = []
      if crypto.tags?
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
      _.forEach(datadb, (val,key) ->
        unless val == true or val== false
          val="\"#{val}\""
        ret+=",\"#{key}\":#{val}"
      )
      ret+="}\n"

console.log(ret)
