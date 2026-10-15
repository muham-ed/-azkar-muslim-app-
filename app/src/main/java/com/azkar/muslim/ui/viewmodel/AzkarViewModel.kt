package com.azkar.muslim.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import com.azkar.muslim.data.AzkarData
import com.azkar.muslim.data.local.PreferencesManager
import com.azkar.muslim.domain.model.AzkarCategory
import com.azkar.muslim.domain.model.Zikr
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

class AzkarViewModel(application: Application) : AndroidViewModel(application) {

    private val prefs = PreferencesManager(application)
    
    private val _categories = MutableStateFlow(loadInitialData())
    val categories: StateFlow<List<AzkarCategory>> = _categories.asStateFlow()

    private fun loadInitialData(): List<AzkarCategory> {
        return AzkarData.categories.map { category ->
            category.copy(
                azkar = category.azkar.map { zikr ->
                    zikr.copy(currentCount = prefs.getZikrCount(zikr.id))
                }
            )
        }
    }

    fun incrementZikr(categoryId: Int, zikrId: Int) {
        _categories.update { currentCategories ->
            currentCategories.map { category ->
                if (category.id == categoryId) {
                    category.copy(
                        azkar = category.azkar.map { zikr ->
                            if (zikr.id == zikrId && zikr.currentCount < zikr.targetCount) {
                                val newCount = zikr.currentCount + 1
                                prefs.saveZikrCount(zikrId, newCount)
                                zikr.copy(currentCount = newCount)
                            } else {
                                zikr
                            }
                        }
                    )
                } else {
                    category
                }
            }
        }
    }

    fun resetCategory(categoryId: Int) {
        _categories.update { currentCategories ->
            currentCategories.map { category ->
                if (category.id == categoryId) {
                    val zikrIds = category.azkar.map { it.id }
                    prefs.clearCategory(zikrIds)
                    category.copy(
                        azkar = category.azkar.map { it.copy(currentCount = 0) }
                    )
                } else {
                    category
                }
            }
        }
    }
}
