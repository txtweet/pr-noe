_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

crypto = _.find cryptos, (crypto) ->
  crypto.git

unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

request
  url : "https://raw.githubusercontent.com/#{crypto.git}/master/COPYING"
  method: 'GET'
.then (body) ->
  console.log body
  #
  # $ = cheerio.load(body)
  #
  # # Garde pour vérifier si la liste des tags à changé
  # tmp = _.clone crypto.tags
  # $('li.cmc-detail-panel-tags > span').each () ->
  #   crypto.tags.push($(@).text())
  # crypto.tags = _.uniq crypto.tags
  #
  # # unless _.isEqual tmp, crypto.tags
  # console.warn "#{crypto.name} [#{tmp}] -> [#{crypto.tags}]"
  #
  # # Récupération de l'url bitcoin
  # $('.cmc-details-panel-links > li').each () ->
  #   if $(@).text() is 'Source Code'
  #     href = $('a', @).attr('href')
  #     if href.startsWith("https://github.com")
  #       crypto.git = href
  #     else
  #       console.warn "Site non github #{href}"
  #       # console.log JSON.stringify cryptos, null, 2
  #       process.exit(1)

# .then () ->
  # console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
