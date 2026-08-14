package com.messconnect.api.web.dto;

import com.messconnect.api.domain.Review;

import java.time.Instant;
import java.util.UUID;

/**
 * API view of a {@link Review}.
 */
public record ReviewResponse(
		UUID id,
		UUID messId,
		UUID userId,
		UUID subscriptionId,
		int ratingTaste,
		int ratingHygiene,
		int ratingQuality,
		int ratingPunctuality,
		double avgRating,
		String comment,
		Instant createdAt) {

	public static ReviewResponse from(Review r) {
		double avg = (r.getRatingTaste() + r.getRatingHygiene()
				+ r.getRatingQuality() + r.getRatingPunctuality()) / 4.0;
		return new ReviewResponse(
				r.getId(), r.getMessId(), r.getUserId(), r.getSubscriptionId(),
				r.getRatingTaste(), r.getRatingHygiene(), r.getRatingQuality(),
				r.getRatingPunctuality(), avg, r.getComment(), r.getCreatedAt());
	}
}
