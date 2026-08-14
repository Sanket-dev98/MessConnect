package com.messconnect.api.service;

import com.messconnect.api.domain.Subscription;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.SubscriptionStatus;
import com.messconnect.api.exception.NotFoundException;
import com.messconnect.api.repository.SubscriptionRepository;
import com.messconnect.api.web.dto.SubscriptionRequest;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * PART 9 — subscriptions. A user subscribes to a mess plan; the caller is the
 * subscriber (derived from the authenticated user).
 */
@Service
public class SubscriptionService {

	private final SubscriptionRepository subscriptionRepository;

	public SubscriptionService(SubscriptionRepository subscriptionRepository) {
		this.subscriptionRepository = subscriptionRepository;
	}

	public List<Subscription> mySubscriptions(User user) {
		return subscriptionRepository.findByUserId(user.getId());
	}

	public Subscription get(UUID id) {
		return subscriptionRepository.findById(id)
				.orElseThrow(() -> new NotFoundException(
						"Subscription not found: " + id));
	}

	@Transactional
	public Subscription create(SubscriptionRequest req, User user) {
		Subscription s = new Subscription();
		s.setUserId(user.getId());
		s.setMessId(req.messId());
		s.setPlanName(req.planName());
		s.setMealType(req.mealType());
		s.setBillingCycle(req.billingCycle());
		s.setPrice(req.price());
		s.setStatus(SubscriptionStatus.ACTIVE);
		return subscriptionRepository.save(s);
	}

	@Transactional
	public void cancel(UUID id, User user) {
		Subscription s = get(id);
		if (!s.getUserId().equals(user.getId())) {
			throw new com.messconnect.api.exception.ForbiddenException(
					"Only the subscriber may cancel");
		}
		s.setStatus(SubscriptionStatus.CANCELLED);
		subscriptionRepository.save(s);
	}
}
