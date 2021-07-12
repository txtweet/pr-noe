_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'

error = (message...) ->
  console.error "ERROR : ", message
  console.log JSON.stringify cryptos, null, 2
  process.exit(2)

crypto = _.find cryptos, (crypto) -> "New" in crypto.tags
unless crypto?
  console.error("Crawl Terminé")
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->
  console.warn "Testing #{crypto.url}"

  $ = cheerio.load(body)
  $('div.tagModalTags___3dJxH > div.tagBadge___3p_Pk').each () ->
    crypto.tags.push($(@).text())

  foundgithub = false
  $('div.linksSection___2uV91 > div.container___2dCiP > ul.content___MhX1h > li').each () ->
    if $(@).text() is 'Source code'
      href = $('a', @).attr('href')
      if href.startsWith("https://github.com")
        # console.warn "Ajout github"
        foundgithub = true
        crypto.git = href
  unless foundgithub
    crypto.tags.push("NoGitHub")

  # token or coin
  foundCoinOrToken = false
  $('div.nameSection___3Hk6F > div.dmQXYG > div').each () ->
    if $(@).text() is 'Coin'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
    else if $(@).text() is 'Token'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
  unless foundCoinOrToken
    error("Type de crypto non trouvé (Coin vs Token) #{crypto.url}")

  if 'Token' in crypto.tags
    foundChain = false
    crypto.forked_data = []
    $('div.guFTCp > div > div').each () ->
      if $('h6', @).text() is 'Explorers'
        $('a', @).each () ->
          href = $(@).attr('href')
          contract = _.find contracts, (aContract) ->
            _.find aContract.urls, (url) ->
              href.startsWith(url)

          if contract?
            foundChain = true
            crypto.tags.push contract.contract
            crypto.forked_data.push href
          else
            error("Type de chaine inconnue", href)

    unless foundChain
      error("Type de token inconnu", crypto)

.catch (err) ->
  error("Crypto non trouvée #{crypto.name}", err)
.then () ->
  crypto.tags = _.without crypto.tags, "New"
  crypto.tags.push("New2")
  if "Stablecoin - Asset-Backed" in crypto.tags
    crypto.tags.push("Stablecoin")
  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify cryptos, null, 2
