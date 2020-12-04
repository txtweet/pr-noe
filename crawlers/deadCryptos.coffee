fileDate = "03122020"

## ethereum -> ethereum
## defi -> DeFi
## asset-management -> Asset management
## smart-contracts -> Smart Contracts
## staking -> staking
## stablecoin -> Stablecoin
## stablecoin-asset-backed -> Stablecoin - Asset-Backed

_ = require 'lodash'
cryptos = require '../cryptos'
fresh = require "../cryptos-#{fileDate}"

newCryptos = 1
oldDeadCryptos = 1
newDeadCryptos = 1

# Remove New keyword from old insert
_.forEach cryptos, (crypto) ->
  crypto.tags = _.without crypto.tags, "New"

  unless "Dead" in crypto.tags
    unless _.find fresh.data, {"name": crypto.name}
      console.error("Monnaie non trouvée #{crypto.name} #{crypto.url}")
      process.exit(1)
      crypto.tags.push("Dead")
      crypto.deaths = ["01011970"]

_.forEach fresh.data, (crypto) ->
  unless cryptos[crypto.name]?
    console.error "#{newCryptos++} - New #{JSON.stringify crypto.name, null, 2}"
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New"].concat(crypto.tags)
      "sawBirth": fileDate

  if crypto.quote.USD.volume_24h is 0
    oldDeadCryptos++
    unless cryptos[crypto.name].deaths?
      cryptos[crypto.name].deaths = []
    cryptos[crypto.name].deaths.push(fileDate)
    if "Dead" not in cryptos[crypto.name].tags
      console.error "#{newDeadCryptos++}/#{oldDeadCryptos} - Dead #{JSON.stringify cryptos[crypto.name].name, null, 2}"
      cryptos[crypto.name].tags.push("Dead")

ordered = {}
_(cryptos).keys().sort().each (key) ->
  ordered[key] = cryptos[key]

console.log JSON.stringify ordered, null, 2
