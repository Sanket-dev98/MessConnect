package com.messconnect.api.repository;

import com.messconnect.api.domain.Review;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReviewRepository extends JpaRepository<Review, UUID> {

	List<Review> findByMessId(UUID messId);

	List<Review> findByUserId(UUID userId);

	boolean existsByUserIdAndSubscriptionId(UUID userId, UUID subscriptionId);
}
