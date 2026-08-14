package com.messconnect.api.web.dto;

import com.messconnect.api.domain.enums.MealType;

/**
 * Search/filter parameters for mess discovery (PART 4). All fields optional.
 */
public record MessFilter(
		String city,
		String area,
		String name,
		Double lat,
		Double lng,
		Double radiusKm,
		Boolean vegOnly,
		MealType mealType) {
}
