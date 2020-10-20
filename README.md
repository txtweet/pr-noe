# pr-noe
## Coinmarket : http://www.coinmarketcap.com
npm install coffee bluebird cheerio request request-promise lodash

Le script charge le fichier cryptos.json

- Pour lancer :
  `coffee ./crawl.coffee > cryptos2.json`
- Puis copier la sortie dans cryptos.json
  `mv ./cryptos2.json cryptos.json`


Un script shell : `lance.sh` automatise l'appel au crawler.

Pour connaître le nombre de cryptos : grep '  },' cryptos.json |wc


## Forkdrop : https://www.forkdrop.io/json/index.json

