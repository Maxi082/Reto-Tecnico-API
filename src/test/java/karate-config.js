function fn() {
  var env = karate.env;
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
    config.baseUrl = 'https://serverest.qa';
  }

  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);

  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config;
}
