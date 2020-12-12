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
  'BGL': 'BGLL'
  'BIGDATACASH': 'BIGDATACASHL'
  'BitBar': 'BitBarL'
  'BitBean': 'BitBeanL'
  'Bitcash Core': 'BitcashCoreL'
  'Bitcash': 'BitcashL'
  'Bitcoin': 'BitcoinL'
  'Bitcoin 2': 'Bitcoin 2L'
  'Bitcoin ABC': 'Bitcoin ABCL'
  'Bitcoin Association': 'Bitcoin AssociationL'
  'Bitcoin Core': 'BitcoinCoreL'
  'Bitcoin Diamond': 'Bitcoin DiamondL'
  'Bitcoin Gold': 'Bitcoin GoldL'
  'Bitcoin Royale': 'Bitcoin RoyaleL'
  'BitcoinZ Community':'BitcoinZ CommunityL'
  'BitCore': 'BitCoreL'
  'BitMoney': 'BitMoneyL'
  'Bitsend Core': 'BitsendCoreL'
  'Bitstar': 'BitstarL'
  'Blackcoin': 'BlackcoinL'
  'BlackCoin': 'BlackcoinL'
  'BLTG': 'BLTGL'
  'BonorumCoin': 'BonorumCoinL'
  'BoostCoin': 'BoostCoinL'
  'bowscoin': 'bowscoinL'
  'BriaCoin': 'BriaCoinL'
  'BTDX': 'BTDXL'
  'CaluraCoin': 'CaluraCoinL'
  'cannation': 'cannationL'
  'Capricoin+': 'Capricoin+L'
  'Carboncoin': 'CarboncoinL'
  'CarebitCoin': 'CarebitCoinL'
  'CashberyCoin': 'CashberyCoinL'
  'CGEN': 'CGENL'
  'Civitas': 'CivitasL'
  'Clam': 'ClamL'
  'ClubCoin': 'ClubCoinL'
  'Compound': 'CompoundL'
  'CounosX Core': 'CounosXCoreL'
  'CSTL': 'CSTLL'
  'CureCoin': 'CureCoinL'
  'Darkpay':'DarkpayL'
  'Dash': 'DashL'
  'DashGreen': 'DashGreenL'
  'Dash Core': 'DashL'
  'DashPay Core': 'DashPayCoreL'
  'DeFi Blockchain': 'DeFi BlockchainL'
  'Denarius': 'DenariusL'
  'Deviant': 'DeviantL'
  'DigiByte': 'DigiByteL'
  'Digitalcoin Core': 'Digitalcoin CoreL'
  'Digiwage': 'DigiwageL'
  'Documentchain': 'DocumentchainL'
  'Doge Core': 'DogeCoreL'
  'dollarcoin': 'dollarcoinL'
  'DMD': 'DMDL'
  'DNotes': 'DNotesL'
  'ECODOLLAR': 'ECODOLLARL'
  'eMark': 'eMarkL'
  'Ember': 'EmberL'
  'Emerald': 'EmeraldL'
  'Emrals Core': 'Emrals CoreL'
  'EnergyCoin': 'EnergyCoinL'
  'Espers': 'EspersL'
  'Eternity group Core': 'Eternity group CoreL'
  'EverGreenCoin .': 'EverGreenCoinL'
  'EvilCoin': 'EvilCoinL'
  'EXCL': 'EXCLL'
  'Fabcoin Core': 'Fabcoin CoreL'
  'FXTC': 'FXTCL'
  'go-ethereum Authors.': 'GOEtereumL'
  'I/OCoin': 'I/OCoinL'
  'Kobocoin': 'KobocoinL'
  'Peerunity': 'PeerunityL'
  'PPCoin': 'PPCoinL'
  'Litecoin': 'LitecoinL'
  'Litecoin Core': 'Litecoin CoreL'
  'LightPayCoin': 'LightPayCoinL'
  'Mini-Blockchain Project': 'Mini-Blockchain ProjectL'
  'NovaCoin': 'NovaCoinL'
  'PIVX': 'PIVXL'
  'Peercoin': 'PeercoinL'
  'Satoshi Nakamoto': 'Satoshi NakamotoL'
  'ShadowCoin': 'ShadowCoinL'
  'Stratis': 'StratisL'
  'VoltCoin': 'VoltCoinL'
  'ZeroOne Core': 'ZeroOneL'
  'Zcash': 'ZcashL'
  'XDNA Core': 'XDNA CoreL'

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
