package com.messconnect.api.web.dto;

import com.messconnect.api.domain.Mess;

import java.time.Instant;
import java.util.UUID;

/**
 * API view of a {@link Mess}. One review per response keeps payloads small and
 * avoids serialising the JPA entity graph.
 */
public record MessResponse(
		UUID id,
		UUID ownerId,
		String name,
		String description,
		String address,
		String area,
		String city,
		String pincode,
		Double latitude,
		Double longitude,
		String phone,
		String imageUrl,
		boolean verified,
		Instant createdAt,
		Instant updatedAt) {

	public static MessResponse from(Mess m) {
		return new MessResponse(
				m.getId(), m.getOwnerId(), m.getName(), m.getDescription(),
				m.getAddress(), m.getArea(), m.getCity(), m.getPincode(),
				m.getLatitude(), m.getLongitude(), m.getPhone(), m.getImageUrl(),
				m.isVerified(), m.getCreatedAt(), m.getUpdatedAt());
	}
}
