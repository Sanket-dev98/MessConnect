package com.messconnect.api.web.dto;

import com.messconnect.api.domain.enums.PaymentMethod;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Inbound payload for a simulated UPI payment (PART 9). No real money moves;
 * the service mocks a gateway response and stores a generated {@code upiRef}.
 */
public record PaymentRequest(
		@NotNull UUID subscriptionId,
		@DecimalMin("0.01") BigDecimal amount,
		PaymentMethod paymentMethod) {
}
