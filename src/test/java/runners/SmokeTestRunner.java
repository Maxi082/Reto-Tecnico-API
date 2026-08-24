package runners;

import com.intuit.karate.junit5.Karate;

class SmokeTestRunner {
    @Karate.Test
    Karate testSmoke() {
        return Karate.run("classpath:usuarios").tags("@smoke");
    }
}
