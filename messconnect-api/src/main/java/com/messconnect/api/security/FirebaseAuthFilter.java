package com.messconnect.api.security;

import com.messconnect.api.domain.User;
import com.messconnect.api.domain.enums.UserRole;
import com.messconnect.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class FirebaseAuthFilter extends OncePerRequestFilter {

    public static final String AUTH_ATTR = "authenticatedUser";

    private final FirebaseAuth firebaseAuth;
    private final UserRepository userRepository;

    @Value("${firebase.service-account.path}")
    private String serviceAccountPath;

    public FirebaseAuthFilter(FirebaseAuth firebaseAuth, UserRepository userRepository) {
        this.firebaseAuth = firebaseAuth;
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String idToken = authHeader.substring(7);
            try {
                // Verify token using Firebase Admin SDK
                FirebaseToken decoded = firebaseAuth.verifyIdToken(idToken);
                String uid = decoded.getUid();

                // Look up or create user in our database
                User user = userRepository.findByFirebaseUid(uid).orElse(null);
                if (user == null) {
                    // Create new user
                    user = new User();
                    user.setFirebaseUid(uid);
                    user.setRole(UserRole.CUSTOMER);
                    user = userRepository.save(user);
                }

                // Set user in request attribute for CurrentUser argument resolver
                request.setAttribute(AUTH_ATTR, user);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token");
                return;
            }
        }
        filterChain.doFilter(request, response);
    }
}
