package com.messconnect.api.web.dto;

import com.messconnect.api.domain.Payment;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

/**
 * API view of a (simulated) {@link Payment}.
 */
public record PaymentResponse(
		UUID id,
		UUID subscriptionId,
		UUID userId,
		BigDecimal amount,
		String currency,
		String status,
		String paymentMethod,
		String upiRef,
		Instant paidAt) {

	public static PaymentResponse from(Payment p) {
		return new PaymentResponse(
				p.getId(), p.getSubscriptionId(), p.getUserId(), p.getAmount(),
				p.getCurrency(), p.getStatus().name(), p.getPaymentMethod().name(),
				p.getUpiRef(), p.getPaidAt());
	}
}
