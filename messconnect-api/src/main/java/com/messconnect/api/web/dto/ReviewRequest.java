package com.messconnect.api.web.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.UUID;

/**
 * Inbound payload for a verified review (PART 8). The caller must hold an
 * active/previous subscription to the mess; {@code subscriptionId} links the
 * review to that subscription and is enforced in {@code ReviewService}.
 */
public record ReviewRequest(
		@NotNull UUID messId,
		@NotNull UUID subscriptionId,
		@Min(1) @Max(5) int ratingTaste,
		@Min(1) @Max(5) int ratingHygiene,
		@Min(1) @Max(5) int ratingQuality,
		@Min(1) @Max(5) int ratingPunctuality,
		@Size(max = 2000) String comment) {
}
