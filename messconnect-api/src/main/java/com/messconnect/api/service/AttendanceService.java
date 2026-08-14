package com.messconnect.api.service;

import com.messconnect.api.domain.Attendance;
import com.messconnect.api.repository.AttendanceRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class AttendanceService {

    private final AttendanceRepository attendanceRepository;

    public AttendanceService(AttendanceRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    public Attendance recordAttendance(Attendance attendance) {
        return attendanceRepository.save(attendance);
    }

    public List<Attendance> getHistory(UUID userId, LocalDate start, LocalDate end) {
        return attendanceRepository.findByUserIdAndDateBetween(userId, start, end);
    }

    public List<Attendance> getDailyAttendance(UUID messId, LocalDate date) {
        return attendanceRepository.findByMessIdAndDate(messId, date);
    }
}
