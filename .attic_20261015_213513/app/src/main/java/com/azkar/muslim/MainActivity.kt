package com.azkar.muslim

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.runtime.*
import com.azkar.muslim.ui.screens.AzkarListScreen
import com.azkar.muslim.ui.screens.HomeScreen
import com.azkar.muslim.ui.theme.AzkarMuslimTheme
import com.azkar.muslim.ui.viewmodel.AzkarViewModel

class MainActivity : ComponentActivity() {
    
    private val viewModel: AzkarViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AzkarMuslimTheme {
                MainNavigation(viewModel)
            }
        }
    }
}

@Composable
fun MainNavigation(viewModel: AzkarViewModel) {
    val categories by viewModel.categories.collectAsState()
    var selectedCategoryId by remember { mutableStateOf<Int?>(null) }

    if (selectedCategoryId == null) {
        HomeScreen(
            categories = categories,
            onCategoryClick = { selectedCategoryId = it }
        )
    } else {
        val category = categories.find { it.id == selectedCategoryId }
        if (category != null) {
            AzkarListScreen(
                category = category,
                onBack = { selectedCategoryId = null },
                onZikrTap = { zikrId ->
                    viewModel.incrementZikr(category.id, zikrId)
                },
                onResetCategory = {
                    viewModel.resetCategory(category.id)
                }
            )
        }
    }
}
