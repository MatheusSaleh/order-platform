// Executado apenas na primeira inicializacao (volume vazio).
// Cria um usuario com permissao restrita ao banco da aplicacao:
// os servicos nunca usam o usuario root do MongoDB.
const appDb = db.getSiblingDB(process.env.MONGO_APP_DB || 'orderdb');

appDb.createUser({
  user: process.env.MONGO_APP_USER,
  pwd: process.env.MONGO_APP_PASSWORD,
  roles: [{ role: 'readWrite', db: appDb.getName() }],
});

print(`Usuario da aplicacao criado em ${appDb.getName()}`);
