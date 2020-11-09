_ = require "lodash"
cryptos = require "../cryptos.json"
MAX_CHILDREN = 20

tree =
  name: "root"
  children: [
    {'name' : 'Binance Chain Contract','children': []}
    {'name' : 'Bitcoin', 'children':[]}
    {'name' : 'Dash','children': []}
    {'name' : 'Ethereum','children': []}
    {'name' : 'Ethereum Classic','children': []}
    {'name' : 'Ethereum Contract','children': []}
    {'name' : 'EOS Contract','children': []}
    {'name' : 'Litecoin','children': []}
    {'name' : 'Monero','children': []}
    {'name' : 'Neo Contract','children': []}
    {'name' : 'Tron Contract','children': []}
  ]

_.forEach cryptos, (crypto) ->
  unless crypto.forked_data?
    if not _.find tree.children, {'name': crypto.name}
      if tree.children.length < MAX_CHILDREN
        tree.children.push
          name: crypto.name
          children: []
  else
    if crypto.forked_data.forked_from.length is crypto.forked_data.block.length
      crypto.forked_data.forked_from.forEach (crpt) ->
        branch = _.find tree.children, {'name': crpt}
        if branch?
          # console.log branch
          if branch.children.length < MAX_CHILDREN
            branch.children.push
              name: crypto.name
        else
          console.log crpt
          console.log crypto
          process.exit()
    else
      console.log crypto
      process.exit(1)

console.log JSON.stringify tree, null, 2
