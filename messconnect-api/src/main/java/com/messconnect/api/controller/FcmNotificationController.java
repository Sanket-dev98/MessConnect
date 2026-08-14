package com.messconnect.api.controller;

import com.messconnect.api.service.FcmNotificationService;
import com.messconnect.api.service.SubscriptionService;
import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * REST controller for sending Firebase Cloud Messaging notifications.
 *
 * <p>Endpoints trigger pushes for key events:
 * - New review posted
 * - Subscription renewal
 * - Menu update
 * - Payment completion
 */
@RestController
@RequestMapping("/api/fcm")
public class FcmNotificationController {

	private final FcmNotificationService fcmService;
	private final SubscriptionService subscriptionService;

	@Autowired
	public FcmNotificationController(FcmNotificationService fcmService,
			SubscriptionService subscriptionService) {
		this.fcmService = fcmService;
		this.subscriptionService = subscriptionService;
	}

	/**
	 * Send a new review notification to a specific user.
	 *
	 * @param userId      The user ID to notify
	 * @param messName    The mess name for the notification context
	 * @param reviewTitle The review title (or excerpt)
	 */
	@PostMapping("/new-review")
	public ResponseEntity<Map<String, String>> sendNewReviewNotification(
			@RequestParam("userId") UUID userId,
			@RequestParam("messName") String messName,
			@RequestParam("reviewTitle") String reviewTitle) {
		String token = getTokenForUser(userId);
		if (token != null) {
			String title = "New Review";
			String body = String.format("You have a new review for %s: %s", messName, reviewTitle);
			fcmService.sendToToken(token, title, body);
		}
		return ResponseEntity.ok(Map.of("status", "sent"));
	}

	/**
	 * Send a subscription renewal notification.
	 *
	 * @param userId       The user ID
	 * @param messName     The mess name
	 * @param planName     The plan name
	 * @param amount       The renewal amount
	 */
	@PostMapping("/subscription-renewal")
	public ResponseEntity<Map<String, String>> sendSubscriptionRenewalNotification(
			@RequestParam("userId") UUID userId,
			@RequestParam("messName") String messName,
			@RequestParam("planName") String planName,
			@RequestParam("amount") double amount) {
		String token = getTokenForUser(userId);
		if (token != null) {
			String title = "Subscription Renewed";
			String body = String.format("Your %s plan for %s has been renewed for $%.2f", planName, messName, amount);
			fcmService.sendToToken(token, title, body);
		}
		return ResponseEntity.ok(Map.of("status", "sent"));
	}

	/**
	 * Send a menu update notification.
	 *
	 * @param userId   The user ID
	 * @param messName The mess name
	 * @param menuItem The updated menu item description
	 */
	@PostMapping("/menu-update")
	public ResponseEntity<Map<String, String>> sendMenuUpdateNotification(
			@RequestParam("userId") UUID userId,
			@RequestParam("messName") String messName,
			@RequestParam("menuItem") String menuItem) {
		String token = getTokenForUser(userId);
		if (token != null) {
			String title = "Menu Updated";
			String body = String.format("New menu items available at %s: %s", messName, menuItem);
			fcmService.sendToToken(token, title, body);
		}
		return ResponseEntity.ok(Map.of("status", "sent"));
	}

	/**
	 * Send a payment completion notification.
	 *
	 * @param userId  The user ID
	 * @param amount  The payment amount
	 */
	@PostMapping("/payment-completed")
	public ResponseEntity<Map<String, String>> sendPaymentCompletedNotification(
			@RequestParam("userId") UUID userId,
			@RequestParam("amount") double amount) {
		String token = getTokenForUser(userId);
		if (token != null) {
			String title = "Payment Completed";
			String body = String.format("Your payment of $%.2f has been completed successfully", amount);
			fcmService.sendToToken(token, title, body);
		}
		return ResponseEntity.ok(Map.of("status", "sent"));
	}

	private String getTokenForUser(UUID userId) {
		// In a full implementation, this would look up the user's FCM token from storage
		// For prototype, return null - the token management is PART 11 / deployment concern
		return null;
	}
}