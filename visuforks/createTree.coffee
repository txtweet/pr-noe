_ = require "lodash"
cryptos = require "../cryptos.json"
MAX_CHILDREN = 200000

tree =
  name: "root"
  children: [
    # {'name' : 'Binance Chain Contract','children': []}
    # {'name' : 'Bitcoin', 'children':[]}
    # {'name' : 'Dash','children': []}
    # {'name' : 'Ethereum','children': []}
    # # {'name' : 'Ethereum Classic','children': []}
    # {'name' : 'Ethereum Contract','children': []}
    # {'name' : 'EOS Contract','children': []}
    # {'name' : 'Litecoin','children': []}
    # {'name' : 'Monero','children': []}
    # {'name' : 'Neo Contract','children': []}
    # {'name' : 'Tron Contract','children': []}
  ]

# Loop 0 main cryptos

_.forEach cryptos, (crypto) ->
  unless crypto.forked_data?
    if not _.find tree.children, {'name': crypto.name}
      tree.children.push
        name: crypto.name
        children: []

# Loop 1 level 1 cryptos
lvl1Crypt = {}
unsolvedCrypt = []
_.forEach cryptos, (crypto) ->
  if crypto.forked_data?
    if crypto.forked_data.forked_from.length is crypto.forked_data.block.length
      crypto.forked_data.forked_from.forEach (crpt) ->
        branch = _.find tree.children, {'name': crpt}
        if branch?
          tmpCrypt =
            'name': crypto.name
            'children': []
          branch.children.push tmpCrypt
          lvl1Crypt[crypto.name] = tmpCrypt
        else
          unsolvedCrypt.push crypto
    else
      console.log crypto
      process.exit(1)

# Lvl 2
_.forEach unsolvedCrypt, (crypto) ->
  if crypto.forked_data?
    if crypto.forked_data.forked_from.length is crypto.forked_data.block.length
      crypto.forked_data.forked_from.forEach (crpt) ->
        branch = lvl1Crypt[crpt]
        # console.log "-> #{branch}"
        if branch?
          children = []
          branch.children.push
            'name': crypto.name
            'children': children
        else
          console.log "Monnaie introuvable #{crpt}"
          process.exit(1)
    else
      console.log unsolvedCrypt
      process.exit(1)

# console.log JSON.stringify unsolvedCrypt, null, 2
console.log JSON.stringify tree, null, 2
