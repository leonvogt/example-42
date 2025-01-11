package dev.box.example.hotwire.viewmodels

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import dev.box.example.PRODUCTION_URL
import dev.box.example.BuildConfig
import dev.box.example.LOCAL_URL
import dev.box.example.SharedPreferencesAccess

class EndpointModel(application: Application):AndroidViewModel(application) {
    private var baseURL: String

    init {
        this.baseURL = loadBaseURL()
    }

    fun setBaseURL(url: String) {
        this.baseURL = url
    }

    private fun loadBaseURL(): String {
        val savedURL = SharedPreferencesAccess.getBaseURL(getApplication<Application>().applicationContext)

        if (savedURL.isNotEmpty()) {
            return savedURL
        }
        if (BuildConfig.DEBUG) {
            return LOCAL_URL
        }
        return PRODUCTION_URL
    }

    val startURL: String
        get() { return "$baseURL/home" }

    val pathConfigurationURL: String
        get() {return "$baseURL/api/v1/android/path_configuration.json"}
}