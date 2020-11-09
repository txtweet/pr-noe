# FAQ
Pour connaître le nombre de cryptos : grep '  },' cryptos.json |wc

# Crawling tools
Ils sont régroupés dans le dossiers crawler. 
Le but est de travailler sur le fichier cryptos.json

## crawl.coffee : http://www.coinmarketcap.com
> Ajoute de nouvelles cryptos au fichier cryptos.json, en se connectant au site coinmarketcap.

npm install coffee bluebird cheerio request request-promise lodash

Le script charge le fichier cryptos.json

- Pour lancer :
  `coffee ./crawl.coffee > cryptos2.json`
- Puis copier la sortie dans cryptos.json
  `mv ./cryptos2.json cryptos.json`

## lance.sh
> Script de lancement des appels pour générer des pauses

Un script shell : `lance.sh` automatise l'appel au crawler.

## InsertForkdropioInCryptos
> Script d'insertion des informations de fork issues de fordrop.io dans le fichier de description des monnaies

wget https://www.forkdrop.io/json/index.json
Charger et sauver le fichier dans forkdropio.json
Ajout d'un script d'injection des données de forkdrop dans cryptos.json
`coffee insertForksInCryptos.coffee`

## crawlTokens
> Script de navigation dans coinmarket pour chercher les monnaies de type token et y insérer les information de fork
Navigue dans la liste cryptos.json pour trouver les forks

## testD3.html
Pour visualiser les données, on utilise d3-hierarchy.
Il faut lancer un serveur minmal python pour charger les données.

>python -m SimpleHTTPServer 8000

Puis ouvrir la page testD3.html
>open http://localhost:8000/testD3.html

### biblio et test d'aide
> Un tutoriel rapide et simple avec un codepen à la fin
https://medium.com/nightingale/making-hierarchy-layouts-with-d3-hierarchy-fdb36d0a9c56
> La doc de d3-hierarchy, plus difficile à prendre en main, car ca passe par l'infrastructure observable
https://observablehq.com/@d3/tidy-tree

# Papiers
https://www.sciencedirect.com/science/article/abs/pii/S0743731520303117?via%3Dihub - SocialBlock
https://www.sciencedirect.com/science/article/abs/pii/S0140366420310252 - BSV-PAGS
