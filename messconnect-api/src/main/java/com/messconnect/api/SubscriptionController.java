package com.messconnect.api;

import com.messconnect.api.domain.User;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.service.SubscriptionService;
import com.messconnect.api.web.dto.SubscriptionRequest;
import com.messconnect.api.web.dto.SubscriptionResponse;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PART 9 — subscriptions. A user manages their own subscriptions.
 */
@RestController
@RequestMapping("/api")
public class SubscriptionController {

	private final SubscriptionService subscriptionService;

	public SubscriptionController(SubscriptionService subscriptionService) {
		this.subscriptionService = subscriptionService;
	}

	@GetMapping("/subscriptions")
	public List<SubscriptionResponse> mine(@CurrentUser User user) {
		return subscriptionService.mySubscriptions(user).stream()
				.map(SubscriptionResponse::from).toList();
	}

	@PostMapping("/subscriptions")
	public SubscriptionResponse create(@Valid @RequestBody SubscriptionRequest req,
			@CurrentUser User user) {
		return SubscriptionResponse.from(subscriptionService.create(req, user));
	}

	@DeleteMapping("/subscriptions/{id}")
	public void cancel(@PathVariable UUID id, @CurrentUser User user) {
		subscriptionService.cancel(id, user);
	}
}
