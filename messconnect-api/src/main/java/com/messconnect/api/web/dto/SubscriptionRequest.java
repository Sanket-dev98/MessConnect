package com.messconnect.api.web.dto;

import com.messconnect.api.domain.enums.BillingCycle;
import com.messconnect.api.domain.enums.MealType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Inbound payload for creating a subscription (PART 9). The user is derived
 * from the authenticated caller.
 */
public record SubscriptionRequest(
		@NotNull UUID messId,
		@NotBlank String planName,
		@NotNull MealType mealType,
		@NotNull BillingCycle billingCycle,
		@DecimalMin("0.0") BigDecimal price) {
}
