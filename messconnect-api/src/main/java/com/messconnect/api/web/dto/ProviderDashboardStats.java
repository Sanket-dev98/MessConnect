package com.messconnect.api.web.dto;

import java.util.Map;

public class ProviderDashboardStats {
    private long activeStudents;
    private Map<String, Long> todayAttendance; // e.g., {"LUNCH": 98, "DINNER": 85}
    private long pendingPayments;
    private double hygieneRating;

    // Getters and Setters
    public long getActiveStudents() { return activeStudents; }
    public void setActiveStudents(long activeStudents) { this.activeStudents = activeStudents; }

    public Map<String, Long> getTodayAttendance() { return todayAttendance; }
    public void setTodayAttendance(Map<String, Long> todayAttendance) { this.todayAttendance = todayAttendance; }

    public long getPendingPayments() { return pendingPayments; }
    public void setPendingPayments(long pendingPayments) { this.pendingPayments = pendingPayments; }

    public double getHygieneRating() { return hygieneRating; }
    public void setHygieneRating(double hygieneRating) { this.hygieneRating = hygieneRating; }
}
