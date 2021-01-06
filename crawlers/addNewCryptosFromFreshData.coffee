unless process.argv[2]?
  console.warn("usage : coffee addNewCryptosFromFreshData <date(jjmmyyyy)>")
  process.exit(1)

fileDate = process.argv[2]
## ethereum -> ethereum
## defi -> DeFi
## asset-management -> Asset management
## smart-contracts -> Smart Contracts
## staking -> staking
## stablecoin -> Stablecoin
## stablecoin-asset-backed -> Stablecoin - Asset-Backed
tagsTables =
  'ai-big-data': 'AI & Big Data'
  'bittrex': 'Bittrex'
  'binance': 'Binance'
  'collectibles-nfts': 'Collectibles & NFTs'
  'content-creation':'Content Creation'
  'dao': 'Dao'
  'defi': 'DeFi'
  'enterprise-solutions':'Enterprise solutions'
  'ethereum': 'Ethereum'
  'ftx': 'Ftx'
  'gaming': 'Gaming'
  'hybrid-pow-pos': 'Hybrid - PoW & PoS'
  'mineable': 'Mineable'
  'media': 'Media'
  'mirror': 'Mirror'
  'payments': 'Payments'
  'platform': 'Platform'
  'polkadot': 'Polkadot'
  'pos': 'PoS'
  'pow': 'PoW'
  'rebase': 'Rebase'
  'scrypt': 'Script'
  'services': 'Services'
  'stablecoin': 'Stablecoin'
  'stablecoin-asset-backed': 'Stablecoin - Asset-Backed'
  'substrate': 'Substrate'
  'token': 'Token'
  'tokenized-stock': 'Tokenized Stock'
  'tron': 'Tron'
  'yield-farming': 'Yield farming'

_ = require 'lodash'
cryptos = require '../cryptos'
fresh = require "../cryptos-#{fileDate}"

newCryptos = 1
oldDeadCryptos = 1
newDeadCryptos = 1

# Remove New keyword from old insert
_.forEach cryptos, (crypto) ->
  crypto.tags = _.without crypto.tags, "New2"

  unless "Dead" in crypto.tags
    unless _.find fresh.data, {"name": crypto.name}
      if "External" not in crypto.tags
        console.error("Monnaie non trouvée dans le nouveaux fichier #{crypto.name} #{crypto.short} #{crypto.url}")
        # process.exit(1)
        crypto.tags.push("Dead")
        crypto.deaths = ["01011970"]

_.forEach fresh.data, (crypto) ->
  if crypto.name.endsWith("FTX")
    crypto.tags.push("ftx")
  if crypto.name.endsWith("Bittrex")
    crypto.tags.push("bittrex")
  if crypto.name.startsWith("Mirrored")
    crypto.tags.push("mirror")
  if crypto.name.endsWith("DOWN")
    crypto.tags.push("binance")
  if crypto.name.endsWith("UP")
    crypto.tags.push("binance")

  unless cryptos[crypto.name]?
    found = _.find (_.values cryptos), {"url": "/currencies/#{crypto.slug}"}
    if found
      console.error "000 - Renommage #{JSON.stringify found.name, null, 2} -> #{JSON.stringify crypto.name, null, 2}"
      process.exit(1)

    console.error "#{newCryptos++} - New #{JSON.stringify crypto.name, null, 2}"
    tmpTags = crypto.tags.map (tag) ->
      unless tagsTables[tag]
        console.error "Tag '#{tag}' inconnu"
        process.exit(1)
      tagsTables[tag]
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New"].concat(tmpTags)
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
