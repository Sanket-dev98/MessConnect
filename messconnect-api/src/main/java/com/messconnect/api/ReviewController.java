package com.messconnect.api;

import com.messconnect.api.domain.User;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.service.ReviewService;
import com.messconnect.api.web.dto.ReviewRequest;
import com.messconnect.api.web.dto.ReviewResponse;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PART 8 — verified reviews. Listing is public; posting is gated to subscribers
 * (enforced in {@link ReviewService}).
 */
@RestController
@RequestMapping("/api/messes")
public class ReviewController {

	private final ReviewService reviewService;

	public ReviewController(ReviewService reviewService) {
		this.reviewService = reviewService;
	}

	@GetMapping("/{messId}/reviews")
	public List<ReviewResponse> byMess(@PathVariable UUID messId) {
		return reviewService.byMess(messId).stream()
				.map(ReviewResponse::from).toList();
	}

	@PostMapping("/{messId}/reviews")
	public ReviewResponse create(@PathVariable UUID messId,
			@Valid @RequestBody ReviewRequest req, @CurrentUser User author) {
		if (!req.messId().equals(messId)) {
			throw new com.messconnect.api.exception.ForbiddenException(
					"Path messId does not match body");
		}
		return ReviewResponse.from(reviewService.create(req, author));
	}
}
