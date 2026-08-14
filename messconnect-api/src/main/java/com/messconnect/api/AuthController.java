package com.messconnect.api;

import com.messconnect.api.domain.User;
import com.messconnect.api.security.CurrentUser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PART 3 probe endpoint — confirms the Firebase auth filter resolves the caller.
 * Requires a valid ID token (see {@link com.messconnect.api.security.FirebaseAuthFilter}).
 * Returns 200 + the resolved {@link User}, or 401 without one.
 */
@RestController
@RequestMapping("/api")
public class AuthController {

	@GetMapping("/me")
	public User me(@CurrentUser User user) {
		return user;
	}
}
