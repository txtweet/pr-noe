_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

licenceName =
  'AcesCoin': 'AcesCoinL'
  'AIB Core': 'AIBL'
  'AmsterdamCoin': 'AmsterdamCoinL'
  'Anoncoin': 'AnoncoinL'
  'Apollon':'ApollonL'
  'AquariusCoin': 'AquariusCoinL'
  'ArepaCoin': 'ArepaCoinL'
  'Aricoin': 'AricoinL'
  'Axiom': 'AxiomL'
  'Backpackercoin': 'BackpackercoinL'
  'Bean Core  www.bitbean.org': 'BeanCoreL'
  'BeetleCoin': 'BeetleCoinL'
  'Beyondcoin Core': 'BeyondcoinCoreL'
  'BitBean': 'BitBeanL'
  'Bitcoin Core': 'BitcoinCoreL'
  'Bitcoin': 'BitcoinL'
  'Blackcoin': 'BlackcoinL'
  'Dash Core': 'DashL'
  'Dash': 'DashL'
  'DigiByte': 'DigiByteL'
  'go-ethereum Authors.': 'GOEtereumL'
  'Kobocoin': 'KobocoinL'
  'PPCoin': 'PPCoinL'
  'Litecoin': 'LitecoinL'
  'NovaCoin': 'NovaCoinL'
  'PIVX': 'PIVXL'
  'ZeroOne Core': 'ZeroOneL'
  'Zcash': "ZcashL"

noLicence = (values, tags) ->
  return (_.findIndex values, (val) -> val in tags) is -1

crypto = _.find cryptos, (crypto) ->
  "NoLicenceFile" not in crypto.tags and
  noLicence((_.values licenceName), crypto.tags) and
  crypto.git?

unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

# console.warn "Recherche : https://raw.githubusercontent.com/#{crypto.git.replace("https://github.com/","")}/master/COPYING"
console.warn "-> #{crypto.name}"
url = "https://raw.githubusercontent.com/#{crypto.git.replace("https://github.com/","")}/master/COPYING"
request
  url : url
  method: 'GET'
.then (body) ->
  lines = body.split('\n')
  lines.forEach (line) ->
    # console.warn "--#{line}--"
    if line.trim().startsWith('Copyright')
      licence = line
      .trim()
      .replace(/.*\d{4} /, '')
      .replace(/The/, '')
      .replace(/Developers|developers/, '')
      .trim()
      unless licenceName[licence]?
        console.error "Nom Licence inconnue #{url}"
        console.error "-> #{licence} / #{crypto.name}"
        console.log JSON.stringify cryptos, null, 2
        process.exit(1)
      else
        unless licenceName[licence] in crypto.tags
          console.warn "Ajout licence #{licenceName[licence]} dans #{crypto.name}"
          crypto.tags.push(licenceName[licence])
        else
          console.warn "License indiquée #{licenceName[licence]} dans #{crypto.name}"
    # else
    #   console.error "Copyright non trouvé -> #{line}, #{line.trim().startsWith('Copyright')}"
    #   console.log JSON.stringify cryptos, null, 2
    #   process.exit(1)

.catch (err) ->
  console.error "Fichier Licence non trouvée #{crypto.name}"
  crypto.tags.push("NoLicenceFile")
.then () ->
  console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
