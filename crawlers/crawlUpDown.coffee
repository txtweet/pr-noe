_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
cryptos = require '../cryptos.json'
request = require 'request-promise'

_.forEach cryptos, (upCrypt) ->
  if upName = /UP$/.exec(upCrypt.name)
    downName = "#{upCrypt.name.slice(0,upName.index)}DOWN"
    downCrypt = _.find cryptos, {"name": downName}
    if downCrypt
      upCrypt.tags = ['Token']
      upCrypt.forked_data =
        "forked_from": [
          "Binance Coin"
        ]
      downCrypt.tags = ['Token']
      downCrypt.forked_data =
        "forked_from": [
          "Binance Coin"
        ]

console.log JSON.stringify cryptos, null, 2
