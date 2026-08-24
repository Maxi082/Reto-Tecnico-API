
function fn(args) {
  args = args || {};

  var timestamp = java.lang.System.currentTimeMillis();
  var randomSuffix = Math.floor(Math.random() * 100000);
  var sufixoUnico = randomSuffix;

  var usuario = {
    nome: args.nome || ('QA Teste ' + sufixoUnico),
    email: args.email || ('qa.' + sufixoUnico + '@gmail.com'),
    password: args.password || 'Senha@123',
    administrador: args.administrador || 'true'
  };

  return usuario;
}
