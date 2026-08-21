/**
 * Schema esperado para el objeto "usuario" tal como lo devuelve la API.
 * Se usa con "match response == schema" dentro de los .feature.
 */
function fn() {
  return {
    nome: '#string',
    email: '#string',
    password: '#string',
    administrador: '#regex (true|false)',
    _id: '#string'
  };
}
