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
          if href.startsWith('https://blockchair.com/ethereum') or
          href.startsWith('https://cn.etherscan.com/') or
          href.startsWith('https://etherscan.io/') or
          href.startsWith('https://ethploer.io/addres') or
          href.startsWith('https://blockchain.coinmarketcap.com/address/ethereum') or
          href.startsWith('https://ethplorer.io/addres') or
          href.startsWith("https://cn.etherscan.com") or
          href.startsWith("https://ethplorer.io/")
            foundChain = true
            crypto.tags.push 'Ethereum'
            crypto.tags.push 'Ethereum Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://bloks.io/tokens')
            foundChain = true
            crypto.tags.push 'EOS'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://bscscan.com') or href.startsWith('https://explorer.binance.org/asset')
            foundChain = true
            crypto.tags.push 'Binance'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://explorer.solana.com') or href.startsWith('https://explorer.binance.org/asset')
            foundChain = true
            crypto.tags.push 'Solana'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://scan.hecochain.com/')
            foundChain = true
            crypto.tags.push 'Huobi ECO'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('http://cdexplorer.net/') or href.startsWith('https://explorer.htmlcoin.com/')
            foundChain = true
            crypto.tags.push 'Codex'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://explorer.knoxfs.com')
            foundChain = true
            crypto.tags.push 'KnoxFS'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://scope.klaytn.com/token')
            foundChain = true
            crypto.tags.push 'KLAYswap Protocol'
            crypto.tags.push 'Other Contract'
            crypto.forked_data.push href
          else if href.startsWith('https://e-money.net') or
          href.startsWith('https://hubble.figment.io/emoney/chains/emoney-2')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'e-Money'
            crypto.forked_data.push href
          else if href.startsWith('https://tronscan.org') or
          href.startsWith('https://trx.tokenview.com/en/token')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'Tron'
            crypto.forked_data.push href
          else if href.startsWith('http://insight.ainetwork.ai/')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'AI'
            crypto.forked_data.push href
          else if href.startsWith('https://wavesexplorer.com/assets')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'Waves'
            crypto.forked_data.push href
          else if href.startsWith('https://beaconscan.com/')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'Beacon'
            crypto.forked_data.push href
          else if href.startsWith('https://explorer.fuse.io/')
            foundChain = true
            crypto.tags.push 'Other Contract'
            crypto.tags.push 'Fuse'
            crypto.forked_data.push href
          else if href.startsWith('https://github.com/helmet-insure/helmet-insure.github.io') or
          href.startsWith('https://fic.filscout.io/en') or
          href.startsWith('https://fic.tokenview.com/en/')
            foundChain = true
          else
            error("Type de chaine inconnue", href)
    unless foundChain
      error("Type de token inconnu", crypto)

.catch (err) ->
  error("Crypto non trouvée #{crypto.name}", err)
.then () ->
  crypto.tags = _.without crypto.tags, "New"
  crypto.tags.push("New2")
  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify cryptos, null, 2
