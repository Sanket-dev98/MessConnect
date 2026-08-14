package com.messconnect.api.repository;

import com.messconnect.api.domain.Attendance;
import com.messconnect.api.domain.enums.MealType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface AttendanceRepository extends JpaRepository<Attendance, UUID> {
    List<Attendance> findByUserIdAndDateBetween(UUID userId, LocalDate startDate, LocalDate endDate);
    List<Attendance> findByMessIdAndDate(UUID messId, LocalDate date);
    long countByMessIdAndDateAndMealTypeAndStatus(UUID messId, LocalDate date, MealType mealType, com.messconnect.api.domain.enums.AttendanceStatus status);
}
