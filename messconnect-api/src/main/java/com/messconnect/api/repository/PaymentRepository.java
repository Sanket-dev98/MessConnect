package com.messconnect.api.repository;

import com.messconnect.api.domain.Payment;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.messconnect.api.domain.enums.PaymentStatus;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, UUID> {

	List<Payment> findBySubscriptionId(UUID subscriptionId);

	List<Payment> findByUserId(UUID userId);

	@Query("SELECT COUNT(p) FROM Payment p JOIN Subscription s ON p.subscriptionId = s.id WHERE s.messId = :messId AND p.status = :status")
	long countByMessIdAndStatus(@Param("messId") UUID messId, @Param("status") PaymentStatus status);
}
