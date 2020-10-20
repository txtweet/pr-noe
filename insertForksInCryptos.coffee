_ = require 'lodash'
cryptos = require './cryptos.json'
forks = require './forkdropio.json'

# console.table cryptos
# console.table forks
console.log "Check for altcoin"
_.forEach forks.altcoin, (fork) ->
  unless cryptos[fork.name]?
    console.error "#{fork.name} introuvable, #{fork.forked_from_cmc}"
  else
    console.log "Ajout #{fork.name}"
    cryptos[fork.name].tags.push("forkedio")
    cryptos[fork.name].forked_from = fork.forked_from
