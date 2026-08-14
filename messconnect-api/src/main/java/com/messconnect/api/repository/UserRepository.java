package com.messconnect.api.repository;

import com.messconnect.api.domain.User;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

	Optional<User> findByFirebaseUid(String firebaseUid);

	Optional<User> findByEmail(String email);
}
