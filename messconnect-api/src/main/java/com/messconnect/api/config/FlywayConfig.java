package com.messconnect.api.config;

import java.util.HashMap;
import java.util.Map;
import org.flywaydb.core.api.configuration.FluentConfiguration;
import org.springframework.boot.flyway.autoconfigure.FlywayConfigurationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FlywayConfig {

    @Bean
    public FlywayConfigurationCustomizer flywayConfigurationCustomizer() {
        return (FluentConfiguration configuration) -> {
            Map<String, String> placeholders = new HashMap<>(configuration.getPlaceholders());
            
            // We use the driver class name or URL to check if it's H2
            Object dataSource = configuration.getDataSource();
            String dsString = (dataSource != null) ? dataSource.toString().toLowerCase() : "";
            
            // Log for debugging if needed (though we can't easily see it if it fails early)
            if (dsString.contains("h2") || dsString.contains("mem")) {
                placeholders.put("uuid_gen", "random_uuid()");
            } else {
                placeholders.put("uuid_gen", "gen_random_uuid()");
            }
            configuration.placeholders(placeholders);
        };
    }
}
