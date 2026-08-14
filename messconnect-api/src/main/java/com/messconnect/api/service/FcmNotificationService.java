package com.messconnect.api.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Service that sends Firebase Cloud Messaging notifications.
 *
 * <p>Uses the injected {@link FirebaseMessaging} bean to send pushes to
 * specific registration tokens. Called by controllers when events occur
 * (new review, subscription renewal, menu update, etc.).
 */
@Service
public class FcmNotificationService {

	private final FirebaseMessaging messaging;

	@Autowired
	public FcmNotificationService(@org.springframework.beans.factory.annotation.Autowired(required = false) FirebaseMessaging messaging) {
		this.messaging = messaging;
	}

	private static final org.slf4j.Logger log =
			org.slf4j.LoggerFactory.getLogger(FcmNotificationService.class);

	private static Map<String, String> mapOf(String... keysAndValues) {
		Map<String, String> map = new HashMap<>();
		for (int i = 0; i < keysAndValues.length; i += 2) {
			if (i + 1 < keysAndValues.length) {
				map.put(keysAndValues[i], keysAndValues[i + 1]);
			}
		}
		return map;
	}

	/**
	 * Sends a notification to a specific device token.
	 *
	 * @param token   The FCM registration token of the target device
	 * @param title   The notification title
	 * @param body    The notification body
	 * @param data    Optional additional data payload
	 * @return MessageId if sent successfully, or empty if token is invalid
	 */
	public Optional<String> sendToToken(String token, String title, String body,
			String... data) {
		if (token == null || token.isEmpty()) {
			log.warn("Attempted to send FCM notification with null/empty token");
			return Optional.empty();
		}

		Map<String, String> dataMap = new HashMap<>();
		if (data != null) {
			for (int i = 0; i < data.length; i += 2) {
				if (i + 1 < data.length) {
					dataMap.put(data[i], data[i + 1]);
				}
			}
		}

		Message message = Message.builder()
				.setToken(token)
				.putAllData(dataMap)
				.build();

		if (messaging == null) {
			log.warn("Firebase Messaging is not initialized. Skipping notification to token {}.", token);
			return Optional.empty();
		}

		try {
			String response = messaging.send(message);
			log.info("FCM notification sent to token {}, response: {}", token, response);
			return Optional.of(response);
		} catch (Exception e) {
			log.error("Failed to send FCM notification to token {}: {}", token, e.getMessage());
			return Optional.empty();
		}
	}

	/**
	 * Sends a notification to a topic. All subscribed devices receive it.
	 *
	 * @param topic   The topic name (e.g. "new-review", "subscription-renewal")
	 * @param title   The notification title
	 * @param body    The notification body
	 * @param data    Optional additional data payload
	 * @return Number of successful sends, or 0 on failure
	 */
	public int sendToTopic(String topic, String title, String body, String... data) {
		Map<String, String> dataMap = new HashMap<>();
		if (data != null) {
			for (int i = 0; i < data.length; i += 2) {
				if (i + 1 < data.length) {
					dataMap.put(data[i], data[i + 1]);
				}
			}
		}

		Message message = Message.builder()
				.setTopic(topic)
				.putAllData(dataMap)
				.build();

		if (messaging == null) {
			log.warn("Firebase Messaging is not initialized. Skipping notification to topic {}.", topic);
			return 0;
		}

		try {
			String response = messaging.send(message);
			log.info("FCM notification sent to topic {}, response: {}", topic, response);
			return 1; // In prototype, assume success
		} catch (Exception e) {
			log.error("Failed to send FCM notification to topic {}: {}", topic, e.getMessage());
			return 0;
		}
	}

	/**
	 * Sends a notification to all devices subscribed to a topic.
	 *
	 * @param topic   The topic name
	 * @param title   The notification title
	 * @param body    The notification body
	 * @param data    Optional additional data payload
	 */
	public void sendToTopicBroadcast(String topic, String title, String body,
			String... data) {
		sendToTopic(topic, title, body, data);
	}
}