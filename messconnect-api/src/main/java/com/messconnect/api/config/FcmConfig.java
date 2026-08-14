package com.messconnect.api.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.messaging.FirebaseMessaging;
import java.io.IOException;
import java.io.InputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;

/**
 * FCM configuration: initializes the Firebase App and provides beans for
 * sending push notifications and Firebase Auth verification.
 */
@Configuration
public class FcmConfig {

	private static final Logger log = LoggerFactory.getLogger(FcmConfig.class);

	@Value("${firebase.service-account.path:classpath:firebase-service-account.json}")
	private Resource serviceAccount;

	@Bean
	public FirebaseApp firebaseApp() throws IOException {
		if (!FirebaseApp.getApps().isEmpty()) {
			return FirebaseApp.getInstance();
		}

		try (InputStream in = serviceAccount.getInputStream()) {
			// If the file is just a stub (very small), we might want to skip it to avoid Linkage/IO errors
			// during initial verification boots.
			if (serviceAccount.contentLength() < 100) {
				log.warn("Firebase service account JSON is a stub. Firebase features will not work.");
				return null;
			}

			FirebaseOptions options = FirebaseOptions.builder()
					.setCredentials(GoogleCredentials.fromStream(in))
					.build();
			FirebaseApp app = FirebaseApp.initializeApp(options);
			log.info("Firebase App initialized for project={}", app.getOptions().getProjectId());
			return app;
		} catch (Exception e) {
			log.error("Failed to initialize Firebase App: {}", e.getMessage());
			return null;
		}
	}

	@Bean
	public FirebaseMessaging firebaseMessaging(org.springframework.beans.factory.ObjectProvider<FirebaseApp> firebaseAppProvider) {
		FirebaseApp firebaseApp = firebaseAppProvider.getIfAvailable();
		if (firebaseApp == null) return null;
		return FirebaseMessaging.getInstance(firebaseApp);
	}

	@Bean
	public FirebaseAuth firebaseAuth(org.springframework.beans.factory.ObjectProvider<FirebaseApp> firebaseAppProvider) {
		FirebaseApp firebaseApp = firebaseAppProvider.getIfAvailable();
		if (firebaseApp == null) return null;
		return FirebaseAuth.getInstance(firebaseApp);
	}
}
