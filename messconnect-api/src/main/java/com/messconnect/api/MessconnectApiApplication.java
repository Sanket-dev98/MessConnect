package com.messconnect.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * MessConnect backend entry point.
 *
 * <p>PART 1 scaffold: Web + JPA + PostgreSQL + Validation + Firebase Admin SDK.
 * Firebase Admin initialisation (service-account JSON) lands in PART 3.
 *
 * <p>PART 2: Datasource + JPA + Flyway are enabled. The Supabase connection
 * string is read from the {@code SUPABASE_DB_URL} environment variable (see
 * application.properties), so no credentials are committed to source.
 */
@SpringBootApplication
public class MessconnectApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(MessconnectApiApplication.class, args);
	}
}
