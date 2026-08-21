function fn() {
  var env = karate.env; // valor de -Dkarate.env, ej: 'dev', 'qa'
  if (!env) {
    env = 'dev';
  }
  karate.log('karate.env activo:', env);

  var config = {
    env: env,
    baseUrl: 'https://serverest.dev'
  };

  if (env === 'dev') {
    config.baseUrl = 'https://serverest.dev';
  } else if (env === 'qa') {
    config.baseUrl = 'https://serverest.dev';
  }

  // Timeouts globales
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);

  // Log del payload/respuesta solo cuando falla, para no ensuciar la consola
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config;
}
