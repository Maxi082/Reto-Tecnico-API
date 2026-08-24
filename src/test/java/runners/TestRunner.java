package runners;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate testTodosLosUsuarios() {
        return Karate.run("classpath:usuarios").karateEnv("dev");
    }
}
