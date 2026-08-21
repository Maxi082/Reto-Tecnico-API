package runners;

import com.intuit.karate.junit5.Karate;

/**
 * Runner principal: ejecuta toda la suite de Usuarios.
 * Uso: mvn test -Dtest=TestRunner
 */
class TestRunner {

    @Karate.Test
    Karate testTodosLosUsuarios() {
        return Karate.run("classpath:usuarios").karateEnv("dev");
    }
}
