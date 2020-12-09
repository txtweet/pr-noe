_ = require 'lodash'
cryptos = require '../cryptos.json'

all = 0
token = 0
coin = 0
euthereum = 0

result = []

_.forEach cryptos, (crypt) ->
  if "New2" in crypt.tags
    all++
    if "Token" in crypt.tags
      token++
      if "Ethereum" in crypt.tags
        euthereum++
      else
        result.push "Token : #{crypt.name}, #{crypt.tags}, #{crypt.url}"

    else
      unless "Coin" in crypt.tags
        console.error "Erreur sur #{JSON.stingify crypt}"
        process.exit(1)
      coin++
      result.push "Coin : #{crypt.name}, #{crypt.tags}, #{crypt.url}"

console.log "---------"
console.log "#{all} nouvelles, dont : #{token} token (dont #{euthereum} Ethereum)"
console.log "#{result.length} autres"
console.log "#{JSON.stringify result.sort(), null, 2}"
