/**
 * Schema esperado para el "envelope" de la respuesta de GET /usuarios.
 * El detalle de cada usuario se valida aparte con "match each" usando
 * usuario-schema.js (ver listar-usuarios.feature).
 */
function fn() {
  return {
    quantidade: '#number',
    usuarios: '#array'
  };
}
