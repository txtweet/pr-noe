unless process.argv[2]?
  console.warn("usage : coffee cryptosToElastic.coffee <date>")
  process.exit(1)

date = process.argv[2]
raw = require '../cryptos-'+date+'.json'

ret=''

for crypto in raw.data
  tags = crypto.tags.map( (x) -> return "\"tag_#{x}\":true" )
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
  \"usd_last_updated\": \"#{crypto.quote.USD.last_updated}\"}\n"

console.log(ret)