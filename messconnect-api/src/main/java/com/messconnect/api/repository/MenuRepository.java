package com.messconnect.api.repository;

import com.messconnect.api.domain.Menu;
import com.messconnect.api.domain.enums.MealType;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MenuRepository extends JpaRepository<Menu, UUID> {

	List<Menu> findByMessId(UUID messId);

	List<Menu> findByMessIdAndMealType(UUID messId, MealType mealType);
}
