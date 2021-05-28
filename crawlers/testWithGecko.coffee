#!/opt/node-v12.6.0-darwin-x64/bin/coffee

_ = require 'lodash'
fs = (require 'fs').promises
Promise = require 'bluebird'
request = require 'request-promise'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'

DELAY = 1200

error = (message...) ->
  console.error "  -> ERROR : ", message

idExceptions = [
  '3x-long-sushi-token'
  '3x-short-sushi-token'
  'anchor-protocol'
  'binance-krw'
  'cvcoin'
  'eos'
  'ignis'
  'likecoin' #cosmos
  'ndau' #cosmos
  'ouroboros' #cosmos
  'max-property-group'
  'metaverse-dualchain-network-architecture'
  'oraclechain'
  'pegnet'
  'triipmiles'
  'utrum'
  'zensports'
]
# console.log _.values(cryptos)
Promise.each (_.values(cryptos)), (crypto) ->
  unless crypto.checkedWithGecko?
    console.log "test #{crypto.name}"
    crypto.checkedWithGecko = {}
    request
      url: "https://api.coingecko.com/api/v3/coins/#{crypto.url.replace("/currencies/", "")}?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
      json: true
    .then (res) ->
      crypto.checkedWithGecko.found = true
      Promise.delay(DELAY)
      .then () ->
        unless res.id in idExceptions
          # console.log JSON.stringify res, null, 2
          if res.asset_platform_id?
            contract = _.find contracts, {"gecko_asset_platform_id": res.asset_platform_id}
            if contract?
              unless contract.contract in crypto.tags
                if res.asset_platform_id is 'ethereum' and res.links?.blockchain_site?[0]?
                  crypto.tags = _.without crypto.tags, "Coin"
                  crypto.tags.push("Token")
                  crypto.tags.push("Ethereum Contract")
                  crypto.tags = _.uniq crypto.tags
                  crypto.forked_data = []
                  crypto.forked_data.push(res.links.blockchain_site[0])
                  console.log "  Ajout ->", (JSON.stringify crypto,null, 2)
                else if res.asset_platform_id is 'tron' and res.links?.blockchain_site?[0]?
                  crypto.tags = _.without crypto.tags, "Coin"
                  crypto.tags.push("Token")
                  crypto.tags.push("Tron Contract")
                  crypto.tags = _.uniq crypto.tags
                  crypto.forked_data = []
                  crypto.forked_data.push(res.links.blockchain_site[0])
                  console.log "  Ajout ->", (JSON.stringify crypto,null, 2)
                else
                  console.log JSON.stringify contract, null, 2
                  console.log (JSON.stringify crypto,null, 2), res
                  process.exit(1)
              else
                console.log "  ->", crypto.name, "ok"
            else
              console.log "Other -->", (JSON.stringify crypto,null, 2), res
              process.exit(1)

          fs.writeFile("../cryptos.json", (JSON.stringify cryptos, null, 2))
    .catch (err) ->
      crypto.checkedWithGecko.found = false
      fs.writeFile("../cryptos.json", (JSON.stringify cryptos, null, 2))
      .then () ->
        Promise.delay(DELAY)
      .then () ->
        error("Crypto non trouvée : #{crypto.name}", err.statusCode)


# process.exit(1)
# crypto = _.find cryptos, (crypto) -> "New" in crypto.tags
# unless crypto?
#   console.error("Crawl Terminé")
#   console.log JSON.stringify cryptos, null, 2
#   process.exit(1)
#
# request
#   url : 'https://coinmarketcap.com'+crypto.url
#   method: 'GET'
# .then (body) ->
#   console.warn "Testing #{crypto.url}"
#
#   $ = cheerio.load(body)
#   $('div.tagModalTags___3dJxH > div.tagBadge___3p_Pk').each () ->
#     crypto.tags.push($(@).text())
#
#   foundgithub = false
#   $('div.linksSection___2uV91 > div.container___2dCiP > ul.content___MhX1h > li').each () ->
#     if $(@).text() is 'Source code'
#       href = $('a', @).attr('href')
#       if href.startsWith("https://github.com")
#         # console.warn "Ajout github"
#         foundgithub = true
#         crypto.git = href
#   unless foundgithub
#     crypto.tags.push("NoGitHub")
#
#   # token or coin
#   foundCoinOrToken = false
#   $('div.nameSection___3Hk6F > div.fGbGGD > div').each () ->
#     if $(@).text() is 'Coin'
#       foundCoinOrToken = true
#       crypto.tags.push($(@).text())
#     else if $(@).text() is 'Token'
#       foundCoinOrToken = true
#       crypto.tags.push($(@).text())
#   unless foundCoinOrToken
#     error("Type de crypto non trouvé (Coin vs Token) #{crypto.url}")
#
#   if 'Token' in crypto.tags
#     foundChain = false
#     crypto.forked_data = []
#     $('div.modal___3Jdkv > div > div > div').each () ->
#       if $('h6', @).text() is 'Explorers'
#         $('a', @).each () ->
#           href = $(@).attr('href')
#           contract = _.find contracts, (aContract) ->
#             _.find aContract.urls, (url) ->
#               href.startsWith(url)
#
#           if contract?
#             foundChain = true
#             crypto.tags.push contract.contract
#             crypto.forked_data.push href
#           else
#             error("Type de chaine inconnue", href)
#
#     unless foundChain
#       error("Type de token inconnu", crypto)
#
# .catch (err) ->
#   error("Crypto non trouvée #{crypto.name}", err)
# .then () ->
#   crypto.tags = _.without crypto.tags, "New"
#   crypto.tags.push("New2")
#   if "Stablecoin - Asset-Backed" in crypto.tags
#     crypto.tags.push("Stablecoin")
#   crypto.tags = _.uniq crypto.tags
#   console.log JSON.stringify cryptos, null, 2
