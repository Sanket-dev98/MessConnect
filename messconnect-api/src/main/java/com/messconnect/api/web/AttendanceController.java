package com.messconnect.api.web;

import com.messconnect.api.domain.Attendance;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.AttendanceStatus;
import com.messconnect.api.domain.enums.MealType;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.service.AttendanceService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    private final AttendanceService attendanceService;

    public AttendanceController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @PostMapping("/scan")
    public Attendance recordAttendance(@CurrentUser User user, @RequestParam UUID messId, @RequestParam MealType mealType) {
        Attendance attendance = new Attendance();
        attendance.setUserId(user.getId());
        attendance.setMessId(messId);
        attendance.setDate(LocalDate.now());
        attendance.setMealType(mealType);
        attendance.setStatus(AttendanceStatus.CHECKED_IN);
        return attendanceService.recordAttendance(attendance);
    }

    @GetMapping("/history")
    public List<Attendance> getHistory(@CurrentUser User user,
                                       @RequestParam(required = false) String start,
                                       @RequestParam(required = false) String end) {
        LocalDate startDate = start != null ? LocalDate.parse(start) : LocalDate.now().minusMonths(1);
        LocalDate endDate = end != null ? LocalDate.parse(end) : LocalDate.now();
        return attendanceService.getHistory(user.getId(), startDate, endDate);
    }
}
