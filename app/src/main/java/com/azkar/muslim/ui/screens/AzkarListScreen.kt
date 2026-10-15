package com.azkar.muslim.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.azkar.muslim.domain.model.AzkarCategory
import com.azkar.muslim.ui.components.ZikrCard
import com.azkar.muslim.ui.theme.DarkGreen

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AzkarListScreen(
    category: AzkarCategory,
    onBack: () -> Unit,
    onZikrTap: (Int) -> Unit,
    onResetCategory: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(category.name, fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(imageVector = Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = onResetCategory) {
                        Icon(imageVector = Icons.Default.Refresh, contentDescription = "Reset All")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = DarkGreen,
                    titleContentColor = MaterialTheme.colorScheme.onPrimary,
                    navigationIconContentColor = MaterialTheme.colorScheme.onPrimary
                )
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp),
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            items(category.azkar, key = { it.id }) { zikr ->
                ZikrCard(
                    zikr = zikr,
                    onTap = { onZikrTap(zikr.id) }
                )
            }
        }
    }
}
