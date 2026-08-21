# Informe de estrategia de automatización — API de Usuarios (ServeRest)

## 1. Objetivo y alcance

Automatizar el ciclo CRUD completo del recurso `/usuarios` de ServeRest, cubriendo casos
positivos y negativos, con validación de esquema JSON y datos de prueba autocontenidos.

## 2. Herramienta elegida: Karate DSL

Se eligió Karate porque combina, en un solo lenguaje declarativo (Gherkin + JS embebido):

- Cliente HTTP nativo (sin necesidad de librerías adicionales tipo RestAssured).
- Aserciones de JSON con **match**, incluyendo comparación estructural (`match ==`) y
  validación de tipos vía markers (`#string`, `#number`, `#regex`, `#array`).
- Soporte para JavaScript embebido en los `.js` de utilidades, lo que permite generar datos
  dinámicos sin depender de un lenguaje de programación externo.
- Reportes HTML nativos y buena integración con Maven/CI.

## 3. Patrones y prácticas aplicadas

### 3.1 Un feature file por endpoint
Cada operación del CRUD (`GET` lista, `POST`, `GET` por ID, `PUT`, `DELETE`) vive en su propio
`.feature`. Esto facilita la trazabilidad entre criterios de aceptación y pruebas, y permite
ejecutar/depurar un endpoint de forma aislada.

### 3.2 Escenarios autocontenidos (self-contained scenarios)
Cada `Scenario` crea sus propios datos de prueba en el `Given`/setup del caso, en lugar de
depender de fixtures compartidas o de un orden de ejecución. Esto:

- Permite ejecución en paralelo sin colisiones de estado.
- Hace cada escenario reproducible de forma aislada (se puede correr un solo `Scenario` y
  sigue siendo válido).
- Evita "test pollution" entre features.

### 3.3 Generación de datos de prueba (Data Builder / Factory)
`usuarios/utils/gerar-usuario.js` actúa como una *factory* de usuarios: genera nombre y email
únicos (timestamp + número aleatorio) en cada llamada, y permite overrides puntuales
(`call read('...') { administrador: 'false' }`) para variar solo el campo que interesa en
cada escenario, siguiendo el principio de **Object Mother / Builder** adaptado a Karate.

### 3.4 Validación de esquema JSON, no solo de valores
Además de comparar valores puntuales (`match response.nome == '...'`), cada respuesta se
valida contra un schema (`usuario-schema.js`) que verifica tipos y presencia de todos los
campos esperados (`nome`, `email`, `password`, `administrador`, `_id`). Esto detecta
regresiones de contrato (ej. un campo que desaparece o cambia de tipo) que una aserción
value-by-value no detectaría.

### 3.5 Tags para segmentación de la suite
Se usan tags `@smoke`, `@positivo` y `@negativo`:

- `@smoke`: subconjunto mínimo de alta confianza para pipelines rápidos (pre-merge).
- `@positivo` / `@negativo`: permiten correr regresión completa o enfocarse en robustez
  ante entradas inválidas.

Esto se apoya con un runner dedicado (`SmokeTestRunner`) además del runner general
(`TestRunner`), para que CI pueda elegir el nivel de cobertura según el contexto
(PR vs. pipeline nocturno).

### 3.6 Configuración centralizada por ambiente
`karate-config.js` centraliza `baseUrl` y timeouts, y soporta `karate.env` para apuntar a
distintos ambientes sin tocar los features — práctica estándar en Karate para mantener las
pruebas independientes del entorno de ejecución.

## 4. Cobertura lograda

- **Casos positivos**: listar, filtrar, crear (admin y no-admin), buscar por ID, actualizar,
  eliminar, con verificación posterior del efecto (ej. tras un DELETE se confirma que el
  `GET` posterior ya no encuentra el registro).
- **Casos negativos**: email duplicado, campos obligatorios faltantes (uno por uno, para
  aislar el mensaje de error específico de cada campo), formato de email inválido, IDs
  inexistentes en `GET`/`PUT`/`DELETE`, y conflicto de email al actualizar.

## 5. Decisiones y trade-offs

- No se usan tokens de autenticación porque los endpoints de `/usuarios` de ServeRest no lo
  requieren (a diferencia de `/produtos`), lo que mantiene la suite simple y enfocada.
- Se optó por escenarios explícitos en vez de `Scenario Outline` para los campos obligatorios
  faltantes, porque cada campo tiene un mensaje de error distinto y escribirlos por separado
  resulta más legible que parametrizar con filas vacías.
- El reporte HTML nativo de Karate se consideró suficiente para el alcance del reto; se dejó
  la dependencia de `cucumber-reporting` como mejora opcional para reportes más elaborados en
  un pipeline de CI real.

## 6. Posibles siguientes pasos

- Integrar el runner en un pipeline de CI (GitHub Actions) que publique el reporte HTML como
  artefacto y bloquee el merge si falla `@smoke`.
- Agregar pruebas de contrato contra un JSON Schema formal (`.json`) usando `karate.match`
  contra un archivo externo, si el equipo adopta OpenAPI/Swagger como fuente de verdad.
- Sumar pruebas de performance básicas (tiempo de respuesta) usando `karate.configure('report', ...)`
  y assertions sobre `responseTime`.
