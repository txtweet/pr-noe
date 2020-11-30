_ = require 'lodash'
cryptos = require '../cryptos.json'
fresh = require '../cryptos-fresh2'

_.forEach fresh.data, (crypto) ->
  unless cryptos[crypto.name]?
    # console.error "Inconnue #{JSON.stringify crypto, null, 2}"
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New","30/11/2020"]

  if crypto.quote.USD.volume_24h is 0
    cryptos[crypto.name].tags.push("Dead")
    cryptos[crypto.name].tags.push("30/11/2020")


ordered = {}
_(cryptos).keys().sort().each (key) ->
  ordered[key] = cryptos[key]

console.log JSON.stringify ordered, null, 2
