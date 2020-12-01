_ = require 'lodash'
cryptos = require '../cryptos.json'

_.forEach cryptos, (crypt) ->
  if crypt.forked_data?.forked_from?
    crypt.tags = _.uniq crypt.tags.concat(crypt.forked_data.forked_from)

console.log JSON.stringify cryptos, null, 2
