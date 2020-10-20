_ = require 'lodash'
cryptos = require './cryptos.json'
forks = require './forkdropio.json'

# console.table cryptos
# console.table forks

# console.log "Check for altcoin"
# _.forEach forks.altcoin, (fork) ->
#   unless cryptos[fork.name]?
#     console.error "#{fork.name} introuvable, #{fork.forked_from_cmc}"
#   else
#     console.log "Ajout #{fork.name}"
#     cryptos[fork.name].tags.push("forked_altcoin")
#     cryptos[fork.name].forked_from = fork.forked_from

console.log "Check for Bitcoin"
_.forEach forks.bitcoin, (fork) ->
  unless cryptos[fork.name]?
    console.error "#{fork.name} introuvable, #{fork.forked_from_cmc}"
  else
    console.log "Ajout #{fork.name}"
    cryptos[fork.name].tags.push("forked_bitcoin")
    cryptos[fork.name].forked_data =
      block: fork.fork_block
      date: fork.fork_date
