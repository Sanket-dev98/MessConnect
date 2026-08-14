package com.messconnect.api.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a controller method parameter to be injected with the authenticated
 * {@link com.messconnect.api.domain.User} resolved by {@link FirebaseAuthFilter}.
 *
 * <pre>{@code
 * @GetMapping("/api/me")
 * public User me(@CurrentUser User user) { ... }
 * }</pre>
 */
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface CurrentUser {
}
