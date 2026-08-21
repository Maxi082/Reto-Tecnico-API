/**
 * Helper para generar datos de prueba de usuarios de forma dinámica.
 * Evita colisiones de email (unique constraint de la API) usando
 * un timestamp + número aleatorio como sufijo.
 *
 * Uso dentro de un .feature:
 *   * def usuarioAleatorio = call read('classpath:usuarios/utils/gerar-usuario.js')
 */
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
