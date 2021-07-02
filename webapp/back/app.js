const express = require('express');
const shell = require('shelljs');

const app = express();

app.use((req, res, next) => {
   res.setHeader('Access-Control-Allow-Origin', '*');
   res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
   next();
 });


app.use('/api/default', (req, res, next) => {
   commande = shell.exec('./pwd.sh');
   res.status(200).json({ message: commande });
   next();
});

app.use('/api/ls', (req, res, next) => {
   commande = shell.exec('./ls.sh');
   res.status(200).json({ message: commande });
   next();
});


app.use('/', (req, res) => {
   res.status(404);
});


module.exports = app;
