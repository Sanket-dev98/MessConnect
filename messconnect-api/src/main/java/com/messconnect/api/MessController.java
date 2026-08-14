package com.messconnect.api;

import com.messconnect.api.domain.User;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.service.MessService;
import com.messconnect.api.web.dto.MessFilter;
import com.messconnect.api.web.dto.MessRequest;
import com.messconnect.api.web.dto.MessResponse;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * PART 4 — mess discovery + owner CRUD. All endpoints require a Firebase ID
 * token (verified by {@link com.messconnect.api.security.FirebaseAuthFilter}).}
 */
@RestController
@RequestMapping("/api/messes")
public class MessController {

	private final MessService messService;

	public MessController(MessService messService) {
		this.messService = messService;
	}

	@GetMapping
	public List<MessResponse> search(
			@RequestParam(required = false) String city,
			@RequestParam(required = false) String area,
			@RequestParam(required = false) String name,
			@RequestParam(required = false) Double lat,
			@RequestParam(required = false) Double lng,
			@RequestParam(required = false) Double radiusKm) {
		MessFilter f = new MessFilter(city, area, name, lat, lng, radiusKm,
				null, null);
		return messService.search(f).stream().map(MessResponse::from).toList();
	}

	@GetMapping("/{id}")
	public MessResponse get(@PathVariable UUID id) {
		return MessResponse.from(messService.get(id));
	}

	@PostMapping
	public MessResponse create(@Valid @RequestBody MessRequest req,
			@CurrentUser User owner) {
		return MessResponse.from(messService.create(req, owner));
	}

	@PutMapping("/{id}")
	public MessResponse update(@PathVariable UUID id,
			@Valid @RequestBody MessRequest req, @CurrentUser User owner) {
		return MessResponse.from(messService.update(id, req, owner));
	}

	@DeleteMapping("/{id}")
	public void delete(@PathVariable UUID id, @CurrentUser User owner) {
		messService.delete(id, owner);
	}
}
