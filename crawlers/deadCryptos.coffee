fileDate = "01122020"

_ = require 'lodash'
cryptos = require '../cryptos'
fresh = require "../cryptos-#{fileDate}"

_.forEach fresh.data, (crypto) ->
  unless cryptos[crypto.name]?
    console.error "New #{JSON.stringify crypto.name, null, 2}"
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New"].concat(crypto.tags)
      "sawBirth": fileDate
      "deaths": []

  if crypto.quote.USD.volume_24h is 0
    console.error "Dead #{JSON.stringify cryptos[crypto.name].name, null, 2}"
    cryptos[crypto.name].deaths = [fileDate]
    if "Dead" not in cryptos[crypto.name].tags
      cryptos[crypto.name].tags.push("Dead")


ordered = {}
_(cryptos).keys().sort().each (key) ->
  ordered[key] = cryptos[key]

console.log JSON.stringify ordered, null, 2
