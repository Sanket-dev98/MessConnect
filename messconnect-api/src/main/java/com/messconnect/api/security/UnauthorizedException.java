package com.messconnect.api.security;

/**
 * Thrown by {@link FirebaseAuthFilter} when a protected request has no valid
 * Firebase ID token. Mapped to HTTP 401 by
 * {@link com.messconnect.api.exception.GlobalExceptionHandler}.
 */
public class UnauthorizedException extends RuntimeException {

	public UnauthorizedException(String message) {
		super(message);
	}

	public UnauthorizedException(String message, Throwable cause) {
		super(message, cause);
	}
}
