#grep -H '  "Coin : ' stat* | cut -d ":" -f 3 | cut -d "]" -f 2 | cut -d "\"" -f 1 |cut -d " " -f 2 > newCoin

fs = require "fs"
stdinBuffer = fs.readFileSync(0)
liste=stdinBuffer.toString().split('\n')
_=require 'lodash'

cryptos=require "../cryptos"

request=""

liste.forEach (elem) ->
  found = _.find (_.values cryptos), {"url": "#{elem}"}
  # unless found?
  #   console.log 'error'
  #   process.exit(1)
  if found? and not ("Dead" in found.tags)
    request+="symbol.keyword:\"#{found.short}\" or "

console.log request.substring(0, request.length - (" or ".length))
