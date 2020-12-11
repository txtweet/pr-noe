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

crypto = _.find cryptos, (crypto) -> "Coin" in crypto.tags
unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->

  $ = cheerio.load(body)

  # Garde pour vérifier si la liste des tags à changé
  tmp = _.clone crypto.tags
  $('li.cmc-detail-panel-tags > span').each () ->
    crypto.tags.push($(@).text())
  crypto.tags = _.uniq crypto.tags

  unless _.isEqual tmp, crypto.tags
    console.warn "#{crypto.name} [#{tmp}] -> [#{crypto.tags}]"

  # Récupération de l'url bitcoin
  url = $('.cmc-details-panel-links > li').each () ->
    if $(@).text() is 'Source Code'
      href = $('a', @).attr('href')
      if href.startsWith("https://github.com")
        crypto.git = href
      else
        console.warn "Site non github #{href}"
        # console.log JSON.stringify cryptos, null, 2
        process.exit(1)

.then () ->
  console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
