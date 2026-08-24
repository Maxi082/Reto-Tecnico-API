# ServeRest API Tests — Karate DSL

Suite de pruebas automatizadas para la API de Usuarios de ServeRest, construida con Karate DSL.

 stack técnico

| Herramienta | Versión | Uso |
|---|---|---|
| Karate DSL | 1.4.1 | Framework de pruebas API (Gherkin + assertions + HTTP client) |
| JUnit 5 | 5.10.2 | Motor de ejecución de los runners |
| Maven | 3.8+ | Gestión de dependencias y build |
| Java | 11+ | Runtime |
| cucumber-reporting | 5.8.1 | Reportes HTML enriquecidos |

 Estructura del proyecto

```
serverest-api-tests/
├── pom.xml
├── README.md
├── INFORME.md
└── src/test/java/
    ├── karate-config.js              # Config global (baseUrl, timeouts, env)
    ├── runners/
    │   ├── TestRunner.java           # Ejecuta toda la suite
    │   └── SmokeTestRunner.java      # Ejecuta solo @smoke
    └── usuarios/
        ├── listar-usuarios.feature       # GET /usuarios
        ├── criar-usuario.feature         # POST /usuarios
        ├── buscar-usuario-por-id.feature # GET /usuarios/{_id}
        ├── atualizar-usuario.feature     # PUT /usuarios/{_id}
        ├── deletar-usuario.feature       # DELETE /usuarios/{_id}
        ├── schemas/
        │   ├── usuario-schema.js         # Schema de un usuario individual
        │   └── usuarios-list-schema.js   # Schema del envelope de la lista
        └── utils/
            └── gerar-usuario.js          # Generador de datos de prueba únicos
```

 Requisitos previos

- Java JDK 11 o superior instalado (`java -version`)
- Maven 3.8+ instalado (`mvn -version`)
- Conexión a internet (la suite corre contra `https://serverest.dev`, no requiere mocks)

 Instalación

```bash
git clone <url-del-repositorio>
cd serverest-api-tests
mvn clean install -DskipTests
```

 Ejecución de las pruebas

**Ejecutar toda la suite:**
```bash
mvn test
```

**Ejecutar solo un feature puntual:**
```bash
mvn test -Dkarate.options="classpath:usuarios/criar-usuario.feature"
```

**Ejecutar solo los smoke tests:**
```bash
mvn test -Dtest=SmokeTestRunner
```

**Ejecutar por ambiente (karate-config.js soporta `karate.env`):**
```bash
mvn test -Dkarate.env=qa
```

**Ejecutar solo escenarios negativos:**
```bash
mvn test -Dkarate.options="--tags @negativo"
```

 Reportes

Karate genera un reporte HTML nativo en:
```
target/karate-reports/karate-summary.html
```