package com.azkar.muslim.domain.model

data class AzkarCategory(
    val id: Int,
    val name: String,
    val azkar: List<Zikr>
)
