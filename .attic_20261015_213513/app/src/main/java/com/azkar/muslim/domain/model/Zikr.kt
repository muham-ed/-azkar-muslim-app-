package com.azkar.muslim.domain.model

data class Zikr(
    val id: Int,
    val text: String,
    val virtue: String,
    val targetCount: Int,
    var currentCount: Int = 0
) {
    val isCompleted: Boolean
        get() = currentCount >= targetCount
}
