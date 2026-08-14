package com.messconnect.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * PART 1 placeholder endpoint to confirm the app boots and serves HTTP.
 * Real controllers (messes, reviews, subscriptions, payments) arrive in PART 4.
 */
@RestController
public class HealthController {

	@GetMapping("/api/health")
	public Map<String, String> health() {
		return Map.of(
				"status", "UP",
				"service", "messconnect-api",
				"version", "0.0.1-SNAPSHOT");
	}
}
