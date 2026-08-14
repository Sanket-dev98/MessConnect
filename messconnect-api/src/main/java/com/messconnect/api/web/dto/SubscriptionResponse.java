package com.messconnect.api.web.dto;

import com.messconnect.api.domain.Subscription;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/**
 * API view of a {@link Subscription}.
 */
public record SubscriptionResponse(
		UUID id,
		UUID userId,
		UUID messId,
		String planName,
		String mealType,
		String billingCycle,
		BigDecimal price,
		String status,
		LocalDate startDate,
		LocalDate endDate,
		Instant createdAt) {

	public static SubscriptionResponse from(Subscription s) {
		return new SubscriptionResponse(
				s.getId(), s.getUserId(), s.getMessId(), s.getPlanName(),
				s.getMealType().name(), s.getBillingCycle().name(), s.getPrice(),
				s.getStatus().name(), s.getStartDate(), s.getEndDate(),
				s.getCreatedAt());
	}
}
