# Intégration des monnaies
Ce répertoire contient les scripts d'intégration des tokens et monnaies dans le fichier crypto.json.

## Intégration des nouvelles monnaies
 - Récupération de la liste sur coinmarketcap dans le fichier toto.json
> wget -O toto.json https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=5000&sort=market_cap&sort_dir=desc&start=1

 - Enregistrement du fichier avec parsing json dans le bon nom
> json < toto.json > ../crypto-<ddmmyyyy>

 - Analyse du fichier pour l'intégration des monnaies dans crypto.json
> coffee ./addNewCryptosFromFreshData.coffee 14122020 > toto.json

*Le script s'arrête si une monnaie est renommée. Il faut corriger le fichier avant*
Si tout est ok, déplacer le fichier à la place du fichier de crypto.json et comiter le. Les nouvelles monnaies sont taguées 'New'

## Crawl des nouvelles monnaies
Lancer le script de récupération des données des monnaie.
Le script intègre, les numéros de token, les tags, et les références github.

> ./lanceUpdateFresh.sh

A la fin on peut lancer le fichier de stat qui génère les statistiques de ces nouvelles newCryptos
> ./coffee ./statistics.coffee <ddmmyyyy>

## Crawl de github pour récupérer les licences
> ./lanceGitHub.sh
