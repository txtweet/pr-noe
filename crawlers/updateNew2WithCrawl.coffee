_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

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
  $('div.linksSection___2uV91 > div.sc-16r8icm-0.gZTdeJ.container___2dCiP > ul.content___MhX1h > li').each () ->
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
  $('div.nameSection___3Hk6F > div.cCqhlo > div').each () ->
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
    $('div.modal___3Jdkv > div > div > div').each () ->
      if $('h6', @).text() is 'Explorers'
        $('a', @).each () ->
          href = $(@).attr('href')
          # console.log '->', href
          if href.startsWith('https://cn.etherscan.com/') or href.startsWith('https://etherscan.io/') or href.startsWith('https://ethplorer.io/address/') or href.startsWith("https://cn.etherscan.com")
            foundChain = true
            crypto.tags.push 'Ethereum'
            crypto.forked_data.push href
          else if href.startsWith('https://bloks.io/tokens')
            foundChain = true
            crypto.tags.push 'EOS'
            crypto.forked_data.push href
          else if href.startsWith('https://bscscan.com') or href.startsWith('https://explorer.binance.org/asset')
            foundChain = true
            crypto.tags.push 'Binance'
            crypto.forked_data.push href
          else if href.startsWith('https://explorer.solana.com') or href.startsWith('https://explorer.binance.org/asset')
            foundChain = true
            crypto.tags.push 'Solana'
            crypto.forked_data.push href
          else if href.startsWith('https://scan.hecochain.com/')
            foundChain = true
            crypto.tags.push 'Huobi ECO'
            crypto.forked_data.push href
          else if href.startsWith('http://cdexplorer.net/') or href.startsWith('https://explorer.htmlcoin.com/')
            foundChain = true
            crypto.tags.push 'Codex'
            crypto.forked_data.push href
          else if href.startsWith('https://explorer.knoxfs.com')
            foundChain = true
            crypto.tags.push 'KnoxFS'
            crypto.forked_data.push href
          else if href.startsWith('https://tronscan.org')
            foundChain = true
            crypto.tags.push 'Tron'
            crypto.forked_data.push href
          else
            error("Type de chaine inconnue", href)
    unless foundChain
      error("Type de token inconnu", crypto)

    # forked_from =[]
    # $('div.cmc-details-contract-lists__container > span').each () ->
    #   forked_from.push(
    #     $(@).text()
    #     .replace("TRON Contract", "Tron")
    #     .replace("Ethereum Contract", "Ethereum")
    #   )
    #
    # bloc = []
    # $('span.cmc-details-contract-lists__item').each () ->
    #   bloc.push($(@).text())
    #
    # crypto.forked_data =
    #   block: bloc
    #   forked_from: forked_from
    #
    # if "Ethereum" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
    #   crypto.tags.push("Ethereum")
    #   console.warn("Token pour #{crypto.name}")
    # else if "Ethereum Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
    #   crypto.tags.push("Ethereum")
    #   console.warn("Token pour #{crypto.name}")
    # else if "Tron Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
    #   crypto.tags.push("Tron")
    #   console.warn("Token pour #{crypto.name}")
    # else if "Binance Coin Contract" in crypto.forked_data.forked_from and crypto.forked_data.forked_from.length is 1
    #   crypto.tags.push("Binance")
    #   console.warn("Token pour #{crypto.name}")
    # else
    #   if _.isEmpty crypto.forked_data.forked_from
    #     console.warn "Token Inconnu à vérifier #{crypto.name}"
    #     delete crypto.forked_data
    #   else
    #     console.warn "Checker pour #{JSON.stringify crypto, null, 2}"
.catch (err) ->
  error("Crypto non trouvée #{crypto.name}", err)
.then () ->
  crypto.tags = _.without crypto.tags, "New"
  crypto.tags.push("New2")
  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify cryptos, null, 2
