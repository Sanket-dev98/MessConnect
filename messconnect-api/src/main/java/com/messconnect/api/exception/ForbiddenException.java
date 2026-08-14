package com.messconnect.api.exception;

/**
 * Thrown when the caller is not allowed to perform the action (e.g. posting a
 * review without an active/previous subscription). Mapped to HTTP 403.
 */
public class ForbiddenException extends RuntimeException {

	public ForbiddenException(String message) {
		super(message);
	}
}
