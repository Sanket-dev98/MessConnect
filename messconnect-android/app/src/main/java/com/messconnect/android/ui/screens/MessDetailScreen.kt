package com.messconnect.android.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

@Composable
fun MessDetailScreen() {
    val scrollState = rememberScrollState()
    
    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(scrollState)
        ) {
            // Header Image Placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(250.dp)
                    .background(Color.Gray)
            )
            
            Spacer(modifier = Modifier.height(100.dp)) // Offset for floating card
            
            // Content Sections
            Column(modifier = Modifier.padding(horizontal = 16.dp)) {
                SectionTitle("Today's Menu")
                MenuSection()
                
                Spacer(modifier = Modifier.height(24.dp))
                SectionTitle("Weekly Schedule")
                WeeklySchedulePlaceholder()
                
                Spacer(modifier = Modifier.height(24.dp))
                SectionTitle("Reviews")
                ReviewsPlaceholder()
                
                Spacer(modifier = Modifier.height(120.dp)) // Padding for bottom bar
            }
        }
        
        // Floating Card
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp)
                .offset(y = 200.dp),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Annapurna Mess",
                        style = MaterialTheme.typography.headlineSmall,
                        fontWeight = FontWeight.Bold
                    )
                    Surface(
                        color = MaterialTheme.colorScheme.secondary,
                        shape = RoundedCornerShape(4.dp)
                    ) {
                        Text(
                            text = "A+", 
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp), 
                            color = Color.White,
                            style = MaterialTheme.typography.labelLarge
                        )
                    }
                }
                
                Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(top = 4.dp)) {
                    Icon(
                        imageVector = Icons.Default.Star, 
                        contentDescription = null, 
                        tint = MaterialTheme.colorScheme.secondary, 
                        modifier = Modifier.size(16.dp)
                    )
                    Text(text = " 4.5", style = MaterialTheme.typography.bodyMedium)
                    Text(text = " (120 reviews)", style = MaterialTheme.typography.bodySmall, color = Color.Gray)
                }
                
                Spacer(modifier = Modifier.height(16.dp))
                
                Text(text = "Seats Available", style = MaterialTheme.typography.labelMedium)
                LinearProgressIndicator(
                    progress = { 0.6f },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(8.dp)
                        .padding(vertical = 4.dp),
                    color = MaterialTheme.colorScheme.primary,
                    trackColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.2f)
                )
                Text(text = "24/40 seats filled", style = MaterialTheme.typography.bodySmall)
            }
        }
        
        // Bottom Bar
        Surface(
            modifier = Modifier.align(Alignment.BottomCenter),
            shadowElevation = 16.dp,
            color = MaterialTheme.colorScheme.surface
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text(text = "Price per month", style = MaterialTheme.typography.labelSmall)
                    Text(
                        text = "₹2,500", 
                        style = MaterialTheme.typography.titleLarge, 
                        fontWeight = FontWeight.Bold, 
                        color = MaterialTheme.colorScheme.primary
                    )
                }
                Button(
                    onClick = { },
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text("VIEW SUBSCRIPTION PLANS")
                }
            }
        }
    }
}

@Composable
private fun SectionTitle(title: String) {
    Text(
        text = title,
        style = MaterialTheme.typography.titleLarge,
        fontWeight = FontWeight.Bold,
        modifier = Modifier.padding(vertical = 8.dp)
    )
}

@Composable
private fun MenuSection() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f))
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Lunch: Paneer Masala, Jeera Rice, Tandoori Roti, Salad", style = MaterialTheme.typography.bodyMedium)
            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
            Text("Dinner: Mix Veg, Plain Rice, Chapati, Dal Tadka", style = MaterialTheme.typography.bodyMedium)
        }
    }
}

@Composable
private fun WeeklySchedulePlaceholder() {
    Text("Mon - Sun: 12:00 PM - 3:00 PM, 7:30 PM - 10:30 PM", color = Color.Gray, style = MaterialTheme.typography.bodyMedium)
}

@Composable
private fun ReviewsPlaceholder() {
    Column {
        repeat(3) {
            Text("User ${it+1}: Great food and hygiene! ⭐⭐⭐⭐⭐", style = MaterialTheme.typography.bodyMedium)
            Spacer(modifier = Modifier.height(8.dp))
        }
    }
}
