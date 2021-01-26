unless process.argv[2]?
  console.warn("usage : coffee ./statistics.coffee <date(jjmmyyyy)>")
  process.exit(1)

currentDate = process.argv[2]

_ = require 'lodash'
cryptos = require '../cryptos.json'

all = 0
token = 0
coin = 0
ethereum = 0
binance = 0
tron = 0
ai = 0

result = []

allDead = 0
dead = []

_.forEach cryptos, (crypt) ->
  # console.log "-> #{crypt.name}"
  if "New2" in crypt.tags
    all++
    if "Token" in crypt.tags
      token++
      if "Ethereum" in crypt.tags
        ethereum++
      else if "Binance" in crypt.tags
        binance++
      else if "Tron" in crypt.tags
        tron++
      else if "AI" in crypt.tags
        ai++
      else
        result.push "Token : #{crypt.name} [#{crypt.tags}] #{crypt.url}"
    else
      unless "Coin" in crypt.tags
        console.error "Erreur sur #{JSON.stringify crypt}"
        process.exit(1)
      coin++
      result.push "Coin : #{crypt.name} [#{crypt.tags}] #{crypt.url}"
  if "Dead" in crypt.tags and crypt.url? and currentDate in crypt.deaths
    allDead++
    if crypt.deaths.length is 1
      dead.push "#{crypt.name} [#{crypt.tags}] #{crypt.url}"

console.log "--------- News"
console.log "#{all} nouvelles, dont : #{token} token (dont #{ethereum} Ethereum, #{binance} Binance, #{tron} Tron, #{ai} AI)"
console.log "#{result.length} à observer"
console.log "#{JSON.stringify result.sort(), null, 2}"
console.log "--------- "
console.log "#{allDead} mortes, dont #{dead.length} à cette date"
console.log "#{JSON.stringify dead.sort(), null, 2}"
