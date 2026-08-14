package com.messconnect.api.web.dto;

import com.messconnect.api.domain.enums.MealType;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

/**
 * Inbound payload for creating/updating a {@code Mess}. Owner is derived from
 * the authenticated user, not supplied by the client.
 */
public record MessRequest(
		@Size(min = 1, max = 200) String name,
		@Size(max = 2000) String description,
		@Size(max = 500) String address,
		@Size(max = 200) String area,
		@Size(max = 200) String city,
		@Size(max = 20) String pincode,
		Double latitude,
		Double longitude,
		@Size(max = 20) String phone,
		@Size(max = 1000) String imageUrl,
		Boolean verified) {

	/** Convenience for price/coords validation that JPA enums can't express. */
	public MessRequest {
		if (latitude != null && (latitude < -90 || latitude > 90)) {
			throw new IllegalArgumentException("latitude must be between -90 and 90");
		}
		if (longitude != null && (longitude < -180 || longitude > 180)) {
			throw new IllegalArgumentException("longitude must be between -180 and 180");
		}
	}
}
