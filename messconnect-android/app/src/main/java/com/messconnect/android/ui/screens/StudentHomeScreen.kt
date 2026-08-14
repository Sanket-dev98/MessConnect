package com.messconnect.android.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.messconnect.android.ui.components.MessCard
import com.messconnect.android.ui.components.NextMealCard

@Composable
fun StudentHomeScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
            .verticalScroll(rememberScrollState())
    ) {
        Spacer(modifier = Modifier.height(48.dp))
        Text(
            text = "Good Afternoon, Aryan!",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        NextMealCard(
            messName = "Annapurna Mess",
            thaliDetails = "Special Veg Thali (Paneer, Dal, Roti, Rice)",
            progress = 0.6f,
            timeRemaining = "25 mins remaining for Lunch",
            onScanClick = { /* Handle Scan */ }
        )
        
        Spacer(modifier = Modifier.height(24.dp))
        
        Text(
            text = "Nearby Messes",
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold
        )
        
        Spacer(modifier = Modifier.height(12.dp))
        
        LazyRow(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(nearbyMesses) { mess ->
                MessCard(
                    name = mess.name,
                    rating = mess.rating,
                    distance = mess.distance
                )
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
    }
}

private data class MessInfo(val name: String, val rating: Double, val distance: String)

private val nearbyMesses = listOf(
    MessInfo("Apna Mess", 4.5, "200m"),
    MessInfo("Royal Thali", 4.2, "450m"),
    MessInfo("Shanti Niwas", 4.8, "800m")
)
