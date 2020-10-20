_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
cryptos = require './cryptos.json'
request = require 'request-promise'

Promise.each _.values(cryptos), (crypto) ->
  if "Token" in crypto.tags
    console.log "Token #{crypto.name}"
    request
      url : 'https://coinmarketcap.com'+crypto.url
      method: 'GET'
    .then (body) ->
      $ = cheerio.load(body)

#__next > div.sc-1mezg3x-0.fHFmDM.cmc-app-wrapper.cmc-app-wrapper--env-prod.cmc-theme--day > div.container.cmc-main-section > div.cmc-main-section__content > div.aiq2zi-0.jvxWIy.cmc-currencies > div.cmc-currencies__details-panel > ul.sc-1mid60a-0.fGOmSh.cmc-details-panel-links > li.cmc-details-contract-lists > div.cmc-details-contract-lists__container > span
      from =[]
      $('div.cmc-details-contract-lists__container > span').each () ->
        from.push($(@).text())
      id = []
      $('span.cmc-details-contract-lists__item').each () ->
        id.push($(@).text())

      cryptos[crypto.name].forked_data =
        block: id
        forked_from: from

      console.error "->", JSON.stringify crypto, null, 2
    .then () ->
      Promise.delay(Math.floor(Math.random() * 10000) + 30000)
  else
    # console.log "Non #{crypto.name}"
    Promise.resolve()

.then () ->
  console.log 'Terminé'
