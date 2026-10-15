package com.azkar.muslim.data.local

import android.content.Context
import android.content.SharedPreferences

class PreferencesManager(context: Context) {
    private val sharedPreferences: SharedPreferences =
        context.getSharedPreferences("azkar_prefs", Context.MODE_PRIVATE)

    fun saveZikrCount(zikrId: Int, count: Int) {
        sharedPreferences.edit().putInt("zikr_$zikrId", count).apply()
    }

    fun getZikrCount(zikrId: Int): Int {
        return sharedPreferences.getInt("zikr_$zikrId", 0)
    }

    fun clearCategory(zikrIds: List<Int>) {
        val editor = sharedPreferences.edit()
        zikrIds.forEach { id ->
            editor.remove("zikr_$id")
        }
        editor.apply()
    }
}
