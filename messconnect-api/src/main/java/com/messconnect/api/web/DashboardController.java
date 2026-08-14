package com.messconnect.api.web;

import com.messconnect.api.domain.Mess;
import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.AttendanceStatus;
import com.messconnect.api.domain.enums.MealType;
import com.messconnect.api.domain.enums.PaymentStatus;
import com.messconnect.api.domain.enums.SubscriptionStatus;
import com.messconnect.api.repository.AttendanceRepository;
import com.messconnect.api.repository.MessRepository;
import com.messconnect.api.repository.PaymentRepository;
import com.messconnect.api.repository.SubscriptionRepository;
import com.messconnect.api.repository.UserRepository;
import com.messconnect.api.security.CurrentUser;
import com.messconnect.api.web.dto.ProviderDashboardStats;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final MessRepository messRepository;
    private final SubscriptionRepository subscriptionRepository;
    private final AttendanceRepository attendanceRepository;
    private final PaymentRepository paymentRepository;
    private final UserRepository userRepository;

    public DashboardController(MessRepository messRepository,
                               SubscriptionRepository subscriptionRepository,
                               AttendanceRepository attendanceRepository,
                               PaymentRepository paymentRepository,
                               UserRepository userRepository) {
        this.messRepository = messRepository;
        this.subscriptionRepository = subscriptionRepository;
        this.attendanceRepository = attendanceRepository;
        this.paymentRepository = paymentRepository;
        this.userRepository = userRepository;
    }

    @GetMapping("/provider")
    public ProviderDashboardStats getProviderStats(@CurrentUser User user) {
        List<Mess> ownedMesses = messRepository.findByOwnerId(user.getId());
        if (ownedMesses.isEmpty()) {
            return new ProviderDashboardStats();
        }
        Mess mess = ownedMesses.get(0); // Assume one mess for now per owner

        ProviderDashboardStats stats = new ProviderDashboardStats();
        stats.setActiveStudents(subscriptionRepository.countByMessIdAndStatus(mess.getId(), SubscriptionStatus.ACTIVE));

        Map<String, Long> attendance = new HashMap<>();
        attendance.put("LUNCH", attendanceRepository.countByMessIdAndDateAndMealTypeAndStatus(
                mess.getId(), LocalDate.now(), MealType.LUNCH, AttendanceStatus.CHECKED_IN));
        attendance.put("DINNER", attendanceRepository.countByMessIdAndDateAndMealTypeAndStatus(
                mess.getId(), LocalDate.now(), MealType.DINNER, AttendanceStatus.CHECKED_IN));
        stats.setTodayAttendance(attendance);

        stats.setPendingPayments(paymentRepository.countByMessIdAndStatus(mess.getId(), PaymentStatus.PENDING));
        stats.setHygieneRating(4.8); // Placeholder, maybe average from reviews

        return stats;
    }

    @GetMapping("/admin")
    public Map<String, Object> getAdminStats(@CurrentUser User user) {
        // Basic check for admin role should be in security config or filter
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("activeMesses", messRepository.count());
        stats.put("monthlyRevenue", 980000); // Placeholder
        stats.put("systemHealth", 99.8);
        return stats;
    }
}
