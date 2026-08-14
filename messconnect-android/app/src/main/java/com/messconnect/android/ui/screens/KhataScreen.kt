package com.messconnect.android.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.messconnect.android.ui.components.StatCard

@Composable
fun KhataScreen() {
    Column(modifier = Modifier.fillMaxSize().padding(horizontal = 16.dp)) {
        Spacer(modifier = Modifier.height(48.dp))
        Text(
            text = "Your Khata",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Row(modifier = Modifier.fillMaxWidth()) {
            StatCard(label = "Meals Remaining", value = "42", modifier = Modifier.weight(1f))
            StatCard(label = "Money Saved", value = "₹1,250", modifier = Modifier.weight(1f))
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        Row(modifier = Modifier.fillMaxWidth()) {
            // Timeline Section
            Column(modifier = Modifier.weight(0.65f)) {
                Text(
                    text = "Check-in History", 
                    style = MaterialTheme.typography.titleLarge, 
                    fontWeight = FontWeight.Bold
                )
                Spacer(modifier = Modifier.height(12.dp))
                LazyColumn(
                    verticalArrangement = Arrangement.spacedBy(0.dp),
                    modifier = Modifier.fillMaxHeight()
                ) {
                    items(checkInData) { item ->
                        TimelineItem(item)
                    }
                }
            }
            
            // Calendar Grid Section (Right Side)
            Column(modifier = Modifier.weight(0.35f).padding(start = 16.dp)) {
                Text(
                    text = "August", 
                    style = MaterialTheme.typography.titleMedium, 
                    fontWeight = FontWeight.Bold
                )
                Spacer(modifier = Modifier.height(8.dp))
                CalendarGrid()
            }
        }
    }
}

@Composable
private fun TimelineItem(item: CheckInItem) {
    Row(verticalAlignment = Alignment.Top) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Box(
                modifier = Modifier
                    .size(12.dp)
                    .background(if (item.checkedIn) Color(0xFF4CAF50) else Color(0xFFF44336), CircleShape)
            )
            Box(
                modifier = Modifier
                    .width(2.dp)
                    .height(48.dp)
                    .background(Color.LightGray)
            )
        }
        
        Spacer(modifier = Modifier.width(12.dp))
        
        Column {
            Text(text = item.date, style = MaterialTheme.typography.labelSmall, color = Color.Gray)
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = item.mealType, 
                    style = MaterialTheme.typography.bodyLarge, 
                    fontWeight = FontWeight.Medium
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = if (item.checkedIn) "Checked-in" else "Absent",
                    color = if (item.checkedIn) Color(0xFF4CAF50) else Color(0xFFF44336),
                    style = MaterialTheme.typography.bodySmall
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
private fun CalendarGrid() {
    Column {
        repeat(6) { row ->
            Row(modifier = Modifier.padding(vertical = 2.dp)) {
                repeat(4) { col ->
                    val index = row * 4 + col
                    Box(
                        modifier = Modifier
                            .size(24.dp)
                            .padding(2.dp)
                            .background(
                                color = when {
                                    index < 12 -> Color(0xFF4CAF50).copy(alpha = 0.6f)
                                    index == 12 -> Color(0xFFF44336).copy(alpha = 0.6f)
                                    else -> Color.LightGray.copy(alpha = 0.3f)
                                },
                                shape = RoundedCornerShape(4.dp)
                            )
                    )
                }
            }
        }
    }
}

private data class CheckInItem(val date: String, val mealType: String, val checkedIn: Boolean)

private val checkInData = listOf(
    CheckInItem("14 Aug", "Lunch", true),
    CheckInItem("13 Aug", "Dinner", true),
    CheckInItem("13 Aug", "Lunch", false),
    CheckInItem("12 Aug", "Dinner", true),
    CheckInItem("12 Aug", "Lunch", true),
    CheckInItem("11 Aug", "Dinner", true),
    CheckInItem("11 Aug", "Lunch", true)
)
