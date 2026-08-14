package com.messconnect.android.ui.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.messconnect.android.ui.theme.NavyPrimary
import com.messconnect.android.ui.theme.OrangeSecondary

@Composable
fun RoleSelectionScreen() {
    var selectedRole by remember { mutableStateOf("Student") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(40.dp))

        // Welcome Illustration Placeholder
        Box(
            modifier = Modifier
                .size(200.dp)
                .background(Color.LightGray, RoundedCornerShape(100.dp)),
            contentAlignment = Alignment.Center
        ) {
            Text("Welcome Illustration", textAlign = TextAlign.Center)
        }

        Spacer(modifier = Modifier.height(32.dp))

        Text(
            text = "Choose Your Role",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            color = NavyPrimary
        )

        Spacer(modifier = Modifier.height(24.dp))

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 32.dp),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                RoleButton(
                    role = "Student",
                    isSelected = selectedRole == "Student",
                    onClick = { selectedRole = "Student" }
                )
                RoleButton(
                    role = "Mess Owner",
                    isSelected = selectedRole == "Mess Owner",
                    onClick = { selectedRole = "Mess Owner" }
                )
                RoleButton(
                    role = "Admin",
                    isSelected = selectedRole == "Admin",
                    onClick = { selectedRole = "Admin" }
                )
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        Button(
            onClick = { println("Get Started clicked with role: $selectedRole") },
            modifier = Modifier
                .fillMaxWidth()
                .height(56.dp),
            colors = ButtonDefaults.buttonColors(containerColor = NavyPrimary),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text(
                text = "GET STARTED",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }
    }
}

@Composable
fun RoleButton(
    role: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    OutlinedButton(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        border = ButtonDefaults.outlineButtonBorder.copy(
            brush = if (isSelected) androidx.compose.ui.graphics.SolidColor(OrangeSecondary) else ButtonDefaults.outlineButtonBorder.brush
        ),
        colors = ButtonDefaults.outlinedButtonColors(
            containerColor = if (isSelected) OrangeSecondary.copy(alpha = 0.1f) else Color.Transparent
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.AccountCircle,
                contentDescription = null,
                tint = if (isSelected) OrangeSecondary else NavyPrimary
            )
            Spacer(modifier = Modifier.width(16.dp))
            Text(
                text = role,
                style = MaterialTheme.typography.bodyLarge,
                color = if (isSelected) OrangeSecondary else NavyPrimary,
                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal
            )
            Spacer(modifier = Modifier.weight(1f))
            RadioButton(
                selected = isSelected,
                onClick = onClick,
                colors = RadioButtonDefaults.colors(selectedColor = OrangeSecondary)
            )
        }
    }
}
