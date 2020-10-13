Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require('request-promise').defaults
#url: 'https://coinmarketcap.com/'+((Math.floor(Math.random() * 37) + 1 ))
  url : 'https://coinmarketcap.com/'
_ = require 'lodash'

sauve = require './cryptos.json'

request()
  .then (body) ->
    console.log body
    $ = cheerio.load(body)
    os.write('./')
    cryptos = []
