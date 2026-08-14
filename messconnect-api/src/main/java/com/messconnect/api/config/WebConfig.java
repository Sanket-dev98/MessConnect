package com.messconnect.api.config;

import com.google.firebase.auth.FirebaseAuth;
import com.messconnect.api.repository.UserRepository;
import com.messconnect.api.security.CurrentUserArgumentResolver;
import com.messconnect.api.security.FirebaseAuthFilter;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * PART 3 — Registers the Firebase auth filter and the {@link CurrentUser}
 * argument resolver.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Autowired(required = false)
	private FirebaseAuth firebaseAuth;

	private final UserRepository userRepository;
	private final CurrentUserArgumentResolver currentUserArgumentResolver;

	public WebConfig(
			UserRepository userRepository,
			CurrentUserArgumentResolver currentUserArgumentResolver) {
		this.userRepository = userRepository;
		this.currentUserArgumentResolver = currentUserArgumentResolver;
	}

	@Bean
	public FirebaseAuthFilter firebaseAuthFilter() {
		return new FirebaseAuthFilter(firebaseAuth, userRepository);
	}

	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
		resolvers.add(currentUserArgumentResolver);
	}
}
