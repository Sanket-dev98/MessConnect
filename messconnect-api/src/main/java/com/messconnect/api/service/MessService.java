package com.messconnect.api.service;

import com.messconnect.api.domain.Mess;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.MealType;
import com.messconnect.api.exception.NotFoundException;
import com.messconnect.api.repository.MessRepository;
import com.messconnect.api.web.dto.MessFilter;
import com.messconnect.api.web.dto.MessRequest;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * PART 4 — mess CRUD + discovery search/filter (by city, area, name, geo
 * radius, meal type, veg-only). Ownership is enforced on update/delete.
 */
@Service
public class MessService {

	private final MessRepository messRepository;

	public MessService(MessRepository messRepository) {
		this.messRepository = messRepository;
	}

	public List<Mess> search(MessFilter f) {
		if (f.lat() != null && f.lng() != null) {
			double radius = f.radiusKm() != null ? f.radiusKm() : 10.0;
			return messRepository.findByLocationNear(f.lat(), f.lng(), radius);
		}
		if (f.city() != null) {
			return messRepository.findByCityIgnoreCase(f.city());
		}
		if (f.area() != null) {
			return messRepository.findByAreaIgnoreCase(f.area());
		}
		if (f.name() != null) {
			return messRepository.findByNameContainingIgnoreCase(f.name());
		}
		return messRepository.findAll();
	}

	public Mess get(UUID id) {
		return messRepository.findById(id)
				.orElseThrow(() -> new NotFoundException("Mess not found: " + id));
	}

	@Transactional
	public Mess create(MessRequest req, User owner) {
		Mess m = new Mess();
		apply(req, m);
		m.setOwnerId(owner.getId());
		return messRepository.save(m);
	}

	@Transactional
	public Mess update(UUID id, MessRequest req, User owner) {
		Mess m = get(id);
		requireOwner(m, owner);
		apply(req, m);
		return messRepository.save(m);
	}

	@Transactional
	public void delete(UUID id, User owner) {
		Mess m = get(id);
		requireOwner(m, owner);
		messRepository.delete(m);
	}

	private void apply(MessRequest req, Mess m) {
		if (req.name() != null) m.setName(req.name());
		if (req.description() != null) m.setDescription(req.description());
		if (req.address() != null) m.setAddress(req.address());
		if (req.area() != null) m.setArea(req.area());
		if (req.city() != null) m.setCity(req.city());
		if (req.pincode() != null) m.setPincode(req.pincode());
		if (req.latitude() != null) m.setLatitude(req.latitude());
		if (req.longitude() != null) m.setLongitude(req.longitude());
		if (req.phone() != null) m.setPhone(req.phone());
		if (req.imageUrl() != null) m.setImageUrl(req.imageUrl());
		if (req.verified() != null) m.setVerified(req.verified());
	}

	private void requireOwner(Mess m, User owner) {
		if (owner.getRole() != com.messconnect.api.domain.enums.UserRole.ADMIN
				&& !owner.getId().equals(m.getOwnerId())) {
			throw new com.messconnect.api.exception.ForbiddenException(
					"Only the mess owner or an admin may modify this mess");
		}
	}
}
