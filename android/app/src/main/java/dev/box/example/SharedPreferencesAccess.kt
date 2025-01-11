package dev.box.example

import android.content.Context
import android.content.SharedPreferences

object SharedPreferencesAccess {
    const val SHARED_PREFERENCES_FILE_KEY = "MobileAppData"
    const val BASE_URL_KEY = "base_url"

    fun setBaseURL(context: Context, baseURL: String) {
        val editor = getPreferences(context).edit()
        editor.putString(BASE_URL_KEY, baseURL)
        editor.apply()
    }

    fun getBaseURL(context: Context?): String {
        return getPreferences(context!!).getString(BASE_URL_KEY, "") ?: ""
    }

    private fun getPreferences(context: Context): SharedPreferences {
        return context.getSharedPreferences(SHARED_PREFERENCES_FILE_KEY, Context.MODE_PRIVATE)
    }
}