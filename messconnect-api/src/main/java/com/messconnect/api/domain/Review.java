package com.messconnect.api.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

/**
 * Verified review (PART 8). Created only for users with an (active/previous)
 * subscription to the mess, enforced at the API layer. Ratings are 1–5 across
 * taste, hygiene, quality and punctuality.
 */
@Entity
@Table(name = "reviews")
public class Review {

	@Id
	@GeneratedValue(strategy = GenerationType.UUID)
	private UUID id;

	@Column(name = "mess_id", nullable = false)
	private UUID messId;

	@Column(name = "user_id", nullable = false)
	private UUID userId;

	@Column(name = "subscription_id", nullable = false)
	private UUID subscriptionId;

	@Column(name = "rating_taste", nullable = false)
	private int ratingTaste;

	@Column(name = "rating_hygiene", nullable = false)
	private int ratingHygiene;

	@Column(name = "rating_quality", nullable = false)
	private int ratingQuality;

	@Column(name = "rating_punctuality", nullable = false)
	private int ratingPunctuality;

	@Column(name = "comment", length = 2000)
	private String comment;

	@Column(name = "created_at", nullable = false, updatable = false)
	private Instant createdAt = Instant.now();

	public UUID getId() {
		return id;
	}

	public void setId(UUID id) {
		this.id = id;
	}

	public UUID getMessId() {
		return messId;
	}

	public void setMessId(UUID messId) {
		this.messId = messId;
	}

	public UUID getUserId() {
		return userId;
	}

	public void setUserId(UUID userId) {
		this.userId = userId;
	}

	public UUID getSubscriptionId() {
		return subscriptionId;
	}

	public void setSubscriptionId(UUID subscriptionId) {
		this.subscriptionId = subscriptionId;
	}

	public int getRatingTaste() {
		return ratingTaste;
	}

	public void setRatingTaste(int ratingTaste) {
		this.ratingTaste = ratingTaste;
	}

	public int getRatingHygiene() {
		return ratingHygiene;
	}

	public void setRatingHygiene(int ratingHygiene) {
		this.ratingHygiene = ratingHygiene;
	}

	public int getRatingQuality() {
		return ratingQuality;
	}

	public void setRatingQuality(int ratingQuality) {
		this.ratingQuality = ratingQuality;
	}

	public int getRatingPunctuality() {
		return ratingPunctuality;
	}

	public void setRatingPunctuality(int ratingPunctuality) {
		this.ratingPunctuality = ratingPunctuality;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Instant getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Instant createdAt) {
		this.createdAt = createdAt;
	}
}
