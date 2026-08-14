package com.messconnect.api.service;

import com.messconnect.api.domain.Review;
import com.messconnect.api.domain.Subscription;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.SubscriptionStatus;
import com.messconnect.api.exception.ConflictException;
import com.messconnect.api.exception.ForbiddenException;
import com.messconnect.api.exception.NotFoundException;
import com.messconnect.api.repository.ReviewRepository;
import com.messconnect.api.repository.SubscriptionRepository;
import com.messconnect.api.web.dto.ReviewRequest;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * PART 8 — verified reviews. A review may only be posted by a user with an
 * active or previous (expired/cancelled) subscription to the mess, and only one
 * review per user per subscription is allowed.
 */
@Service
public class ReviewService {

	private final ReviewRepository reviewRepository;
	private final SubscriptionRepository subscriptionRepository;

	public ReviewService(ReviewRepository reviewRepository,
			SubscriptionRepository subscriptionRepository) {
		this.reviewRepository = reviewRepository;
		this.subscriptionRepository = subscriptionRepository;
	}

	public List<Review> byMess(UUID messId) {
		return reviewRepository.findByMessId(messId);
	}

	@Transactional
	public Review create(ReviewRequest req, User author) {
		Subscription sub = subscriptionRepository.findById(req.subscriptionId())
				.orElseThrow(() -> new NotFoundException(
						"Subscription not found: " + req.subscriptionId()));

		// The subscription must belong to this user and this mess.
		if (!sub.getUserId().equals(author.getId())) {
			throw new ForbiddenException("Subscription does not belong to you");
		}
		if (!sub.getMessId().equals(req.messId())) {
			throw new ForbiddenException(
					"Subscription is for a different mess than the review target");
		}

		// Active or previous (expired/cancelled) subscribers only.
		boolean allowed = sub.getStatus() == SubscriptionStatus.ACTIVE
				|| sub.getStatus() == SubscriptionStatus.EXPIRED
				|| sub.getStatus() == SubscriptionStatus.CANCELLED;
		if (!allowed) {
			throw new ForbiddenException(
					"Only subscribers (active or previous) may post a review");
		}

		if (reviewRepository.existsByUserIdAndSubscriptionId(
				author.getId(), req.subscriptionId())) {
			throw new ConflictException(
					"You have already reviewed this subscription");
		}

		Review r = new Review();
		r.setMessId(req.messId());
		r.setUserId(author.getId());
		r.setSubscriptionId(req.subscriptionId());
		r.setRatingTaste(req.ratingTaste());
		r.setRatingHygiene(req.ratingHygiene());
		r.setRatingQuality(req.ratingQuality());
		r.setRatingPunctuality(req.ratingPunctuality());
		r.setComment(req.comment());
		return reviewRepository.save(r);
	}
}
