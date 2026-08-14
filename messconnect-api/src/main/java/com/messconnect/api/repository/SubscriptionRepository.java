package com.messconnect.api.repository;

import com.messconnect.api.domain.Subscription;
import com.messconnect.api.domain.enums.SubscriptionStatus;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SubscriptionRepository extends JpaRepository<Subscription, UUID> {

	List<Subscription> findByUserId(UUID userId);

	List<Subscription> findByMessId(UUID messId);

	List<Subscription> findByUserIdAndStatus(UUID userId, SubscriptionStatus status);

	List<Subscription> findByMessIdAndUserId(UUID messId, UUID userId);

	long countByMessIdAndStatus(UUID messId, SubscriptionStatus status);
}
