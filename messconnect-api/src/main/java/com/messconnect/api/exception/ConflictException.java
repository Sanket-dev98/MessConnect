package com.messconnect.api.exception;

/**
 * Thrown when a request conflicts with existing state (e.g. a duplicate review
 * for the same subscription). Mapped to HTTP 409.
 */
public class ConflictException extends RuntimeException {

	public ConflictException(String message) {
		super(message);
	}
}
