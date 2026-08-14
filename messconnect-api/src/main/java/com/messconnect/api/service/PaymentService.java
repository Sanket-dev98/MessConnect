package com.messconnect.api.service;

import com.messconnect.api.domain.Payment;
import com.messconnect.api.domain.Subscription;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.PaymentMethod;
import com.messconnect.api.domain.enums.PaymentStatus;
import com.messconnect.api.exception.NotFoundException;
import com.messconnect.api.repository.PaymentRepository;
import com.messconnect.api.repository.SubscriptionRepository;
import com.messconnect.api.web.dto.PaymentRequest;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * PART 9 — simulated UPI payments. No real money moves: the "gateway" is mocked
 * and a {@code upiRef} reference is generated so the flow can be tested end to
 * end. A real gateway would replace {@link #mockGateway}.
 */
@Service
public class PaymentService {

	private final PaymentRepository paymentRepository;
	private final SubscriptionRepository subscriptionRepository;

	public PaymentService(PaymentRepository paymentRepository,
			SubscriptionRepository subscriptionRepository) {
		this.paymentRepository = paymentRepository;
		this.subscriptionRepository = subscriptionRepository;
	}

	public List<Payment> myPayments(User user) {
		return paymentRepository.findByUserId(user.getId());
	}

	@Transactional
	public Payment pay(PaymentRequest req, User user) {
		Subscription sub = subscriptionRepository.findById(req.subscriptionId())
				.orElseThrow(() -> new NotFoundException(
						"Subscription not found: " + req.subscriptionId()));
		if (!sub.getUserId().equals(user.getId())) {
			throw new com.messconnect.api.exception.ForbiddenException(
					"Subscription does not belong to you");
		}

		Payment p = new Payment();
		p.setSubscriptionId(sub.getId());
		p.setUserId(user.getId());
		p.setAmount(req.amount());
		p.setPaymentMethod(req.paymentMethod() != null
				? req.paymentMethod() : PaymentMethod.UPI);

		boolean success = mockGateway(req, user);
		if (success) {
			p.setStatus(PaymentStatus.SUCCESS);
			p.setUpiRef("UPI-" + UUID.randomUUID().toString().substring(0, 12)
					.toUpperCase());
			p.setPaidAt(Instant.now());
		} else {
			p.setStatus(PaymentStatus.FAILED);
		}
		return paymentRepository.save(p);
	}

	/**
	 * Mock UPI gateway. Always succeeds for the prototype. Replace with a real
	 * provider (e.g. Razorpay/UPI deep link) in production.
	 */
	private boolean mockGateway(PaymentRequest req, User user) {
		return req.amount() != null
				&& req.amount().signum() > 0;
	}
}
