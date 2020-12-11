_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

licenceName =
  'The Bitcoin Core developers': 'BitcoinL'
  'Bitcoin Developers': 'BitcoinL'
  'The Dash Core developers': 'DashL'
  'Dash Developers': 'DashL'
  'The ZeroOne Core developers': 'ZeroOneL'
  'The Zcash developers': "ZcashL"

noLicence = (values, tags) ->
  return (_.findIndex values, (val) -> val in tags) isnt 0

crypto = _.find cryptos, (crypto) ->
  "NoLicenceFile" not in crypto.tags and
  noLicence((_.values licenceName), crypto.tags) and
  crypto.git

unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

# console.log "Recherche : https://raw.githubusercontent.com/#{crypto.git.replace("https://github.com/","")}/master/COPYING"
console.warn "-> #{crypto.name}"
url = "https://raw.githubusercontent.com/#{crypto.git.replace("https://github.com/","")}/master/COPYING"
request
  url : url
  method: 'GET'
.then (body) ->
  lines = body.split('\n')
  lines.forEach (line) ->
    # console.log line
    if line.startsWith('Copyright (c)')
      licence = line.replace(/Copyright \(c\) \d{4}-\d{4} /, '')
      unless licenceName[licence]?
        console.error "Licence non trouvé #{url}"
        console.error "-> #{licence}"
        console.log JSON.stringify cryptos, null, 2
        process.exit(1)
      else
        unless licenceName[licence] in crypto.tags
          console.warn "Ajout licence #{licenceName[licence]} dans #{crypto.name}"
          crypto.tags.push(licenceName[licence])
        else
          console.warn "License indiquée #{licenceName[licence]} dans #{crypto.name}"

.catch (err) ->
  console.error "Licence non trouvée #{crypto.name}"
  crypto.tags.push("NoLicenceFile")
.then () ->
  console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
