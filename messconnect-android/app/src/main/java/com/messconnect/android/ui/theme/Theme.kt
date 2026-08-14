package com.messconnect.android.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColorScheme = lightColorScheme(
    primary = NavyPrimary,
    secondary = OrangeSecondary,
    background = CreamBackground,
    surface = White,
    onPrimary = White,
    onSecondary = White,
    onBackground = DarkGrey,
    onSurface = DarkGrey
)

@Composable
fun MessLinkTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = Typography,
        content = content
    )
}
