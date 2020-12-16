# Exporter la data vers Elastic

## Data déjà existante
 La collections doit être pré-crée pour permettre l'import. 
Pour cela lancer `./exportElastic/initCollection.sh`

 
 Pour importer les données déjà collectées dans Elastic il suffit de lancer le script `toelasticexist.sh`. 
 Avant de le lancer, il faut ajouter au fichier (dans la liste de la boucle for) l'ensemble des dates pour lesquelles un fichier extrait est disponible. 
 
 Depuis la racine du git, lancer `./exportElastic/toelasticexist.sh`
 Vérifier dans les fichiers ans_DDMMYYYY.log contienne bien l'information `errors: false`.
 
 ## Ajouter la dernière data 
 ### TODO : FAIRE LE SCRIPT
 
 
 Lancer le script `./exportElastic/toelastic.sh (YYMMDD)`
 Le paramètre `YYMMDD` correspond à la date du fichier à importer. 
 C'est un paramètre optionnel, la valeur par-défaut correspond à la date du jour. 
 
 
 
 ## Récuperer et importer la data
 TODO