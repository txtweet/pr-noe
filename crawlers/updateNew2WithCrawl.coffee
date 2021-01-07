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

error = (message...) ->
  console.error "ERROR : ", message...
  # console.log JSON.stringify cryptos, null, 2
  process.exit(1)

crypto = _.find cryptos, (crypto) -> "New" in crypto.tags
unless crypto?
  error("Crawl Terminé")

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->
  console.warn "Testing #{crypto.url}"
  crypto.tags = _.without crypto.tags, "New"
  crypto.tags.push("New2")

  $ = cheerio.load(body)
  foundTags = false
  $('div.tagModalTags___3dJxH > div.tagBadge___3p_Pk').each () ->
    foundTags = true
    crypto.tags.push($(@).text())
  unless foundTags
    error("Tags non trouvés #{crypto.url}")

  foundgithub = false
  $('div.linksSection___2uV91 > div.sc-16r8icm-0.gZTdeJ.container___2dCiP > ul.content___MhX1h > li').each () ->
    if $(@).text() is 'Source code'
      href = $('a', @).attr('href')
      if href.startsWith("https://github.com")
        console.warn "Ajout github"
        foundgithub = true
        crypto.git = href
  unless foundgithub
    error("Github non trouvé #{crypto.url}")

  # token or coin
  foundCoinOrToken = false
  $('div.nameSection___3Hk6F > div.cCqhlo > div').each () ->
    if $(@).text() is 'Coin'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
    else if $(@).text() is 'Token'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
  unless foundCoinOrToken
    error("Type de crypto non trouvé (Coin vs Token) #{crypto.url}")

  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify crypto, null, 2
  process.exit()

  if 'Token' in crypto.tags
    forked_from =[]
    $('div.cmc-details-contract-lists__container > span').each () ->
      forked_from.push(
        $(@).text()
        .replace("TRON Contract", "Tron")
        .replace("Ethereum Contract", "Ethereum")
      )

    bloc = []
    $('span.cmc-details-contract-lists__item').each () ->
      bloc.push($(@).text())

    crypto.forked_data =
      block: bloc
      forked_from: forked_from

    if "Ethereum" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
      crypto.tags.push("Ethereum")
      console.warn("Token pour #{crypto.name}")
    else if "Ethereum Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
      crypto.tags.push("Ethereum")
      console.warn("Token pour #{crypto.name}")
    else if "Tron Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
      crypto.tags.push("Tron")
      console.warn("Token pour #{crypto.name}")
    else if "Binance Coin Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
      crypto.tags.push("Binance")
      console.warn("Token pour #{crypto.name}")
    else
      if _.isEmpty crypto.forked_data.forked_from
        console.warn "Token Inconnu à vérifier #{crypto.name}"
        delete crypto.forked_data
      else
        console.warn "Checker pour #{JSON.stringify crypto, null, 2}"
.catch (err) ->
  error("Crypto non trouvée #{crypto.name}", err)
.then () ->
  console.log JSON.stringify cryptos, null, 2
