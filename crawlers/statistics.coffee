unless process.argv[2]?
  console.warn("usage : coffee ./statistics.coffee <date(jjmmyyyy)>")
  process.exit(1)

currentDate = process.argv[2]

_ = require 'lodash'
cryptos = require '../cryptos.json'

all = 0
token = 0
coin = 0
euthereum = 0
result = []

allDead = 0
dead = []

_.forEach cryptos, (crypt) ->
  if "New2" in crypt.tags
    all++
    if "Token" in crypt.tags
      token++
      if "Ethereum" in crypt.tags
        euthereum++
      else
        result.push "Token : #{crypt.name} [#{crypt.tags}] #{crypt.url}"

    else
      unless "Coin" in crypt.tags
        console.error "Erreur sur #{JSON.stingify crypt}"
        process.exit(1)
      coin++
      result.push "Coin : #{crypt.name} [#{crypt.tags}] #{crypt.url}"
  if "Dead" in crypt.tags and currentDate in crypt.deaths
    allDead++
    if crypt.deaths.length is 1
      dead.push "#{crypt.name} [#{crypt.tags}] #{crypt.url}"

console.log "--------- News"
console.log "#{all} nouvelles, dont : #{token} token (dont #{euthereum} Ethereum)"
console.log "#{result.length} à observer"
console.log "#{JSON.stringify result.sort(), null, 2}"
console.log "--------- "
console.log "#{allDead} mortes, dont #{dead.length} à cette date"
console.log "#{JSON.stringify dead.sort(), null, 2}"
