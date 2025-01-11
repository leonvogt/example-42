package dev.box.example

import android.annotation.SuppressLint
import android.app.Application
import dev.box.example.hotwire.fragment.WebFragment
import dev.box.example.hotwire.fragment.WebModalFragment
import dev.box.example.hotwire.fragment.WebBottomSheetFragment
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.defaultFragmentDestination
import dev.hotwire.navigation.config.registerFragmentDestinations

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        configureApp()
    }

    @SuppressLint("HardwareIds")
    private fun configureApp() {
        // Loads the path configuration
        Hotwire.loadPathConfiguration(
            context = this,
            location = PathConfiguration.Location(
                assetFilePath = "json/configuration.json",
                remoteFileUrl = "$LOCAL_URL/api/mobile/v1/ios/path_configuration.json"
            )
        )

        // Set the default fragment destination
        Hotwire.defaultFragmentDestination = WebFragment::class

        // Register fragment destinations
        Hotwire.registerFragmentDestinations(
            WebFragment::class,
            WebModalFragment::class,
            WebBottomSheetFragment::class
        )
    }
}
