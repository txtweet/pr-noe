_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

# _.forEach cryptos, (crypt) ->
#   if crypt.forked_data?.forked_from?
#     crypt.tags = _.uniq crypt.tags.concat(crypt.forked_data.forked_from)
#
# console.log JSON.stringify cryptos, null, 2

crypto = _.find cryptos, (crypto) -> _.isEmpty crypto.tags

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->
  $ = cheerio.load(body)
  #__next > div.sc-1mezg3x-0.fHFmDM.cmc-app-wrapper.cmc-app-wrapper--env-prod.cmc-theme--day > div.container.cmc-main-section > div.cmc-main-section__content > div.aiq2zi-0.jvxWIy.cmc-currencies > div.cmc-currencies__details-panel > ul.sc-1mid60a-0.fGOmSh.cmc-details-panel-links > li.cmc-detail-panel-tags
  $('li.cmc-detail-panel-tags > span').each () ->
    crypto.tags.push($(@).text())

  if 'Token' in crypto.tags
    forked_from =[]
    $('div.cmc-details-contract-lists__container > span').each () ->
      forked_from.push($(@).text())

    bloc = []
    $('span.cmc-details-contract-lists__item').each () ->
      bloc.push($(@).text())

    crypto.forked_data =
      block: bloc
      forked_from: forked_from

  if "Ethereum Contract" in crypto.forked_data.forked_from
    crypto.tags.push("Ethereum")
  else
    console.error("Forked a modifier #{JSON.stringify crypto, null, 2}")

.then () ->
  console.log JSON.stringify cryptos, null, 2
