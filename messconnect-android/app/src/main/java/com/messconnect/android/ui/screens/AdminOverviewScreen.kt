package com.messconnect.android.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdminOverviewScreen() {
    // Dark theme colors for this screen
    val darkBackground = Color(0xFF121212)
    val darkSurface = Color(0xFF1E1E1E)
    val onDarkSurface = Color.White

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Platform Overview", fontWeight = FontWeight.Bold, color = onDarkSurface) },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = darkBackground),
                actions = {
                    IconButton(onClick = { /* TODO */ }) {
                        Icon(Icons.Default.Settings, contentDescription = "Settings", tint = onDarkSurface)
                    }
                }
            )
        },
        containerColor = darkBackground
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp)
        ) {
            // Stats Grid
            Row(modifier = Modifier.fillMaxWidth()) {
                AdminStatCard("Total Users", "5,240", Modifier.weight(1f), darkSurface, onDarkSurface)
                AdminStatCard("Active Messes", "48", Modifier.weight(1f), darkSurface, onDarkSurface)
            }
            Row(modifier = Modifier.fillMaxWidth()) {
                AdminStatCard("Monthly Revenue", "₹4.2L", Modifier.weight(1f), darkSurface, onDarkSurface)
                AdminStatCard("System Health", "99.9%", Modifier.weight(1f), darkSurface, onDarkSurface)
            }

            Spacer(modifier = Modifier.height(24.dp))

            Text(
                "Platform Control Center",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = onDarkSurface,
                modifier = Modifier.padding(bottom = 12.dp)
            )

            val controls = listOf(
                ControlItem("MESS MANAGEMENT", Icons.Default.Store, false),
                ControlItem("STUDENT ISSUES", Icons.Default.Report, true),
                ControlItem("REPORT CENTER", Icons.Default.Assessment, false),
                ControlItem("PAYMENT GATEWAYS", Icons.Default.Payments, false),
                ControlItem("SETTINGS", Icons.Default.Settings, false)
            )

            LazyColumn(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(controls) { control ->
                    ControlRow(control, darkSurface, onDarkSurface)
                }
            }

            Button(
                onClick = { /* TODO */ },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp)
                    .height(56.dp),
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.primary)
            ) {
                Text("ADMIN ACTIONS", fontWeight = FontWeight.Bold)
            }
        }
    }
}

@Composable
fun AdminStatCard(label: String, value: String, modifier: Modifier, backgroundColor: Color, contentColor: Color) {
    Card(
        modifier = modifier.padding(4.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = backgroundColor)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(label, style = MaterialTheme.typography.labelMedium, color = contentColor.copy(alpha = 0.6f))
            Spacer(modifier = Modifier.height(4.dp))
            Text(value, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, color = contentColor)
        }
    }
}

@Composable
fun ControlRow(control: ControlItem, backgroundColor: Color, contentColor: Color) {
    var isEnabled by remember { mutableStateOf(true) }
    
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = backgroundColor)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(control.icon, contentDescription = null, tint = contentColor.copy(alpha = 0.8f))
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(control.label, color = contentColor, fontWeight = FontWeight.Medium)
                    if (control.hasFlag) {
                        Spacer(modifier = Modifier.width(8.dp))
                        Surface(
                            color = Color.Red,
                            shape = RoundedCornerShape(4.dp)
                        ) {
                            Text(
                                "Flagged Issue",
                                color = Color.White,
                                fontSize = 8.sp,
                                modifier = Modifier.padding(horizontal = 4.dp, vertical = 2.dp)
                            )
                        }
                    }
                }
            }
            Switch(
                checked = isEnabled,
                onCheckedChange = { isEnabled = it },
                colors = SwitchDefaults.colors(
                    checkedThumbColor = MaterialTheme.colorScheme.primary,
                    checkedTrackColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.5f)
                )
            )
        }
    }
}

data class ControlItem(val label: String, val icon: ImageVector, val hasFlag: Boolean)
