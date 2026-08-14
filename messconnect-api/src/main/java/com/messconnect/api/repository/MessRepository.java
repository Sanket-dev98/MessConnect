package com.messconnect.api.repository;

import com.messconnect.api.domain.Mess;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MessRepository extends JpaRepository<Mess, UUID> {

	List<Mess> findByCityIgnoreCase(String city);

	List<Mess> findByAreaIgnoreCase(String area);

	List<Mess> findByNameContainingIgnoreCase(String name);

	List<Mess> findByOwnerId(UUID ownerId);

	/** Simple distance filter using the equirectangular approximation. */
	@Query("""
			select m from Mess m
			where m.latitude is not null and m.longitude is not null
			  and (6371 * sqrt(
					((m.latitude - :lat) * (m.latitude - :lat))
					+ ((m.longitude - :lng) * (m.longitude - :lng))
					  * cos(radians(:lat)) * cos(radians(:lat))
				  )) <= :radiusKm
			""")
	List<Mess> findByLocationNear(@Param("lat") double lat,
			@Param("lng") double lng,
			@Param("radiusKm") double radiusKm);
}
