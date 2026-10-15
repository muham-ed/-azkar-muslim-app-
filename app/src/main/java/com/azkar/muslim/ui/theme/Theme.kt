package com.azkar.muslim.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColorScheme = lightColorScheme(
    primary = DarkGreen,
    onPrimary = LightBeige,
    background = SoftBeige,
    surface = CardBackground,
    onSurface = TextDark
)

@Composable
fun AzkarMuslimTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}
