package runners;

import com.intuit.karate.junit5.Karate;

/**
 * Runner de smoke tests: ejecuta solo los escenarios etiquetados @smoke.
 * Pensado para pipelines de CI donde se necesita feedback rápido.
 * Uso: mvn test -Dtest=SmokeTestRunner
 */
class SmokeTestRunner {

    @Karate.Test
    Karate testSmoke() {
        return Karate.run("classpath:usuarios").tags("@smoke");
    }
}
