package com.messconnect.api;

import com.messconnect.api.domain.User;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.service.PaymentService;
import com.messconnect.api.web.dto.PaymentRequest;
import com.messconnect.api.web.dto.PaymentResponse;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PART 9 — simulated UPI payments. A user views/pays their own subscriptions.
 */
@RestController
@RequestMapping("/api")
public class PaymentController {

	private final PaymentService paymentService;

	public PaymentController(PaymentService paymentService) {
		this.paymentService = paymentService;
	}

	@GetMapping("/payments")
	public List<PaymentResponse> mine(@CurrentUser User user) {
		return paymentService.myPayments(user).stream()
				.map(PaymentResponse::from).toList();
	}

	@PostMapping("/payments")
	public PaymentResponse pay(@Valid @RequestBody PaymentRequest req,
			@CurrentUser User user) {
		return PaymentResponse.from(paymentService.pay(req, user));
	}
}
