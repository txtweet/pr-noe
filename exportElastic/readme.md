# Tester la connexion
curl -u elastic:xxxx http://localhost:9100
Si un pont ssh est créé.

#Host wired
#  User sfrenot
#  HostName wired.citi.insa-lyon.fr
#  LocalForward 9100 wired.citi.insa-lyon.fr:9200


# Exporter la data vers Elastic
 La collections doit être pré-crée pour permettre l'import.
Pour cela lancer `./exportElastic/initCollection.sh`

Les scripts doivent être lancés depuis le dossier `pr-noe`.
## Data déjà existante


 Pour importer les données déjà collectées dans Elastic il suffit de lancer le script `toelasticexist.sh`.
 Avant de le lancer, il faut ajouter au fichier (dans la liste de la boucle for) l'ensemble des dates pour lesquelles un fichier extrait est disponible.

 Depuis la racine du git, lancer `./exportElastic/toelasticexist.sh`
 Vérifier dans les fichiers ans_DDMMYYYY.log contienne bien l'information `errors: false`.

 ## Ajouter la dernière data



 Lancer le script `./exportElastic/toelastic.sh (DDMMYYYY)`
 Le paramètre `DDMMYYYY` correspond à la date du fichier à importer.
 C'est un paramètre optionnel, la valeur par-défaut correspond à la date du jour.



 ## Récuperer et importer la data
 TODO
