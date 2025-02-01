package dev.box.example

import android.annotation.SuppressLint
import android.app.Application
import androidx.lifecycle.ViewModelProvider
import dev.box.example.hotwire.NavigationDecisionHandler
import dev.box.example.hotwire.bridgeComponents.BaseURLComponent
import dev.box.example.hotwire.bridgeComponents.PermissionsComponent
import dev.box.example.hotwire.fragment.WebFragment
import dev.box.example.hotwire.fragment.WebModalFragment
import dev.box.example.hotwire.fragment.WebBottomSheetFragment
import dev.box.example.hotwire.viewmodels.EndpointModel
import dev.hotwire.core.bridge.BridgeComponentFactory
import dev.hotwire.core.bridge.KotlinXJsonConverter
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.defaultFragmentDestination
import dev.hotwire.navigation.config.registerBridgeComponents
import dev.hotwire.navigation.config.registerFragmentDestinations
import dev.hotwire.navigation.config.registerRouteDecisionHandlers
import dev.hotwire.navigation.routing.AppNavigationRouteDecisionHandler
import dev.hotwire.navigation.routing.BrowserRouteDecisionHandler

class MainApplication : Application() {
    val endpointModel: EndpointModel by lazy {
        ViewModelProvider.AndroidViewModelFactory.getInstance(this).create(EndpointModel::class.java)
    }

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
                remoteFileUrl = endpointModel.pathConfigurationURL
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

        // Register bridge components
        Hotwire.registerBridgeComponents(
            BridgeComponentFactory("base-url", ::BaseURLComponent),
            BridgeComponentFactory("permissions", ::PermissionsComponent)
        )

        // Register route decision handlers
        // https://native.hotwired.dev/android/reference#handling-url-routes
        Hotwire.registerRouteDecisionHandlers(
            NavigationDecisionHandler(),
            AppNavigationRouteDecisionHandler(),
            BrowserRouteDecisionHandler()
        )

        // Set configuration options
        Hotwire.config.debugLoggingEnabled = BuildConfig.DEBUG
        Hotwire.config.webViewDebuggingEnabled = BuildConfig.DEBUG
        Hotwire.config.jsonConverter = KotlinXJsonConverter()
    }
}
