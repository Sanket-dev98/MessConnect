package com.messconnect.android.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Security
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.messconnect.android.ui.theme.NavyPrimary
import com.messconnect.android.ui.theme.OrangeSecondary

@Composable
fun LoginScreen() {
    var phoneNumber by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(40.dp))

        // Logo Section
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            Icon(
                imageVector = Icons.Default.Security,
                contentDescription = null,
                tint = OrangeSecondary,
                modifier = Modifier.size(32.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(
                text = "MESSLINK",
                style = MaterialTheme.typography.headlineLarge,
                fontWeight = FontWeight.ExtraBold,
                color = NavyPrimary,
                letterSpacing = 2.sp
            )
        }

        Spacer(modifier = Modifier.height(48.dp))

        Text(
            text = "Welcome Back",
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold,
            color = NavyPrimary
        )
        Text(
            text = "Login to your account",
            style = MaterialTheme.typography.bodyMedium,
            color = Color.Gray
        )

        Spacer(modifier = Modifier.height(32.dp))

        // Phone Number Input
        OutlinedTextField(
            value = phoneNumber,
            onValueChange = { if (it.length <= 10) phoneNumber = it },
            modifier = Modifier.fillMaxWidth(),
            leadingIcon = {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.padding(start = 12.dp)
                ) {
                    Text("+91", fontWeight = FontWeight.Bold, color = NavyPrimary)
                    Icon(Icons.Default.ArrowDropDown, contentDescription = null)
                    Box(modifier = Modifier.width(1.dp).height(24.dp).background(Color.LightGray).padding(horizontal = 8.dp))
                }
            },
            placeholder = { Text("Phone Number") },
            singleLine = true,
            shape = RoundedCornerShape(12.dp),
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = NavyPrimary,
                unfocusedBorderColor = Color.LightGray
            ),
            readOnly = true // Custom keypad will handle input
        )

        Spacer(modifier = Modifier.height(32.dp))

        // Numeric Keypad
        NumericKeypad(
            onNumberClick = { num ->
                if (phoneNumber.length < 10) phoneNumber += num
            },
            onDeleteClick = {
                if (phoneNumber.isNotEmpty()) phoneNumber = phoneNumber.dropLast(1)
            }
        )

        Spacer(modifier = Modifier.height(24.dp))

        // OTP Indicators (as requested: below the keypad)
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            repeat(4) {
                Box(
                    modifier = Modifier
                        .size(12.dp)
                        .clip(CircleShape)
                        .background(Color.LightGray.copy(alpha = 0.5f))
                )
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        Button(
            onClick = { println("Confirm & Login clicked with phone: $phoneNumber") },
            modifier = Modifier
                .fillMaxWidth()
                .height(56.dp),
            colors = ButtonDefaults.buttonColors(containerColor = NavyPrimary),
            shape = RoundedCornerShape(12.dp),
            enabled = phoneNumber.length == 10
        ) {
            Text(
                text = "CONFIRM & LOGIN",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }
    }
}

@Composable
fun NumericKeypad(
    onNumberClick: (String) -> Unit,
    onDeleteClick: () -> Unit
) {
    val keys = listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "DEL")

    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        modifier = Modifier.padding(horizontal = 24.dp)
    ) {
        items(keys) { key ->
            if (key.isNotEmpty()) {
                Box(
                    modifier = Modifier
                        .aspectRatio(1.5f)
                        .clip(RoundedCornerShape(8.dp))
                        .clickable {
                            if (key == "DEL") onDeleteClick() else onNumberClick(key)
                        },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = key,
                        style = MaterialTheme.typography.headlineSmall,
                        fontWeight = FontWeight.Bold,
                        color = NavyPrimary
                    )
                }
            } else {
                Spacer(modifier = Modifier.size(48.dp))
            }
        }
    }
}
