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
  'amm': 'AMM'
  'atomic-swaps':'Atomic Swaps'
  'asset-backed-coin': 'Asset Backed Coin'
  'asset-management': 'Asset management'
  'bittrex': 'Bittrex'
  'binance': 'Binance'
  'binance-labs-portfolio': 'Binance Labs Portfolio'
  'binance-launchpad': 'Binance Launchpad'
  'binance-smart-chain': 'Binance Smart Chain'
  'centralized-exchange': 'Centralized exchange'
  'coinbase-ventures-portfolio': 'Coinbase Ventures Portfolio'
  'collectibles-nfts': 'Collectibles & NFTs'
  'communications-social-media': 'Communications & Social Media'
  'content-creation':'Content Creation'
  'cosmos-ecosystem': 'Cosmos Ecosystem'
  'crowdfunding': 'Crowdfunding'
  'cybersecurity': 'Cybersecurity'
  'dao': 'Dao'
  'dao-maker': 'DAO Maker'
  'dao-maker-launchpad': 'Dao Maker Launchpad'
  'dapp': 'DApp'
  'decentralized-exchange': 'Decentralized exchange'
  'defi': 'DeFi'
  'defi-index': 'DeFi Index'
  'derivatives': 'Derivatives'
  'dex': 'Dex'
  'discount-token': 'Discount token'
  'distributed-computing': 'Distributed Computing'
  'dot-ecosystem': 'DOT Ecosystem'
  'dpos': 'DPoS'
  'duckstarter': 'DuckSTARTER'
  'e-commerce': 'E-commerce'
  'energy': 'Energy'
  'enterprise-solutions':'Enterprise solutions'
  'entertainment': 'Entertainment'
  'eth-2-0-staking':'ETH 2.0 Staking'
  'ethereum': 'Ethereum'
  'events': 'Events'
  'fan-token': 'Fan token'
  'filesharing': 'Filesharing'
  'ftx': 'Ftx'
  'gambling': 'Gambling'
  'gaming': 'Gaming'
  'governance': 'Governance'
  'groestl': 'Groestl'
  'hardware': 'Hardware'
  'hashkey-capital-portfolio': 'Hashkey Capital Portfolio'
  'heco': 'Heco'
  'hybrid-pow-pos': 'Hybrid - PoW & PoS'
  'identity': 'Identity'
  'insurance': 'Insurance'
  'launchpad':  'Launchpad'
  'logistics': 'Logistics'
  'loyalty': 'Loyalty'
  'marketplace': 'Marketplace'
  'masternodes': 'Masternodes'
  'medium-of-exchange': 'Medium of Exchange'
  'mineable': 'Mineable'
  'media': 'Media'
  'memes': 'Memes'
  'mirror': 'Mirror'
  'music': 'Music'
  'oracles': 'Oracles'
  'pantera-capital-portfolio': 'Pantera Capital Portfolio'
  'payments': 'Payments'
  'philanthropy': 'Philanthropy'
  'platform': 'Platform'
  'polkadot': 'Polkadot'
  'polkastarter': 'Polkastarter'
  'polkadot-ecosystem': 'Polkadot Ecosystem'
  'poolz-finance': 'Poolz Finance'
  'pos': 'PoS'
  'pos-30': 'POS 3.0'
  'pow': 'PoW'
  'prediction-markets': 'Prediction Markets'
  'privacy': 'Privacy'
  'quantum-resistant': 'Quantum-Resistant'
  'rebase': 'Rebase'
  'reputation': 'Reputation'
  'scaling': 'Scaling'
  'scrypt': 'Script'
  'seigniorage': 'Seigniorage'
  'services': 'Services'
  'sharding': 'Sharding'
  'smart-contracts': 'Smart Contracts'
  'social-money': 'Social Money'
  'social-token': 'Social Token'
  'sports': 'Sports'
  'stablecoin': 'Stablecoin'
  'stablecoin-asset-backed': 'Stablecoin - Asset-Backed'
  'staking': 'Staking'
  'state-channels': 'State channels'
  'storage': 'Storage'
  'substrate': 'Substrate'
  'synthetic': 'Synthetic'
  'technology': 'Technology'
  'token': 'Token'
  'tokenized-stock': 'Tokenized Stock'
  'tron': 'Tron'
  'wallet': 'Wallet'
  'wrapped-tokens': 'Wrapped Tokens'
  'x11': 'X11'
  'x13': 'X13'
  'yearn-partnerships': 'Yearn Partnerships'
  'yield-farming': 'Yield farming'
  'yield-aggregator': 'Yield Aggregator'
  'zero-knowledge-proofs': 'Zero Knowledge Proofs'

_ = require 'lodash'
cryptos = require '../cryptos'
fresh = require "../files/cryptos-#{fileDate}"

newCryptos = 1
oldDeadCryptos = 1
newDeadCryptos = 1

# Remove New keyword from old insert
_.forEach cryptos, (crypto) ->
  crypto.tags = _.without crypto.tags, "New2"

  unless "Dead" in crypto.tags
    unless _.find fresh.data, {"name": crypto.name}
      if "External" not in crypto.tags
        console.error("Monnaie supprimée du fichier #{crypto.name} #{crypto.short} #{crypto.url}")
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
      console.error "ERREUR : 000 - Renommage #{JSON.stringify found.name, null, 2} -> #{JSON.stringify crypto.name, null, 2}"
      console.log JSON.stringify ordered, null, 2
      process.exit(1)

    console.error "#{newCryptos++} - New #{JSON.stringify crypto.name, null, 2}"
    tmpTags = crypto.tags.map (tag) ->
      unless tagsTables[tag]
        console.error "ERREUR : Tag '#{tag}' inconnu"
        console.log JSON.stringify ordered, null, 2
        process.exit(1)
      tagsTables[tag]
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New"].concat(tmpTags)
      "sawBirth": fileDate

  if crypto.quote.USD.volume_24h is 0 #or crypto.quote.USD.market_cap is 0
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

console.error "FINI - OK"
console.log JSON.stringify ordered, null, 2
