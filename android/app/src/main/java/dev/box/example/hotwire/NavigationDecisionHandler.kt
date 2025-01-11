package dev.box.example.hotwire

import androidx.core.net.toUri
import dev.box.example.MainApplication
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import dev.hotwire.navigation.routing.Router

class NavigationDecisionHandler : Router.RouteDecisionHandler {
    override val name = "app-navigation-router"

    override val decision = Router.Decision.NAVIGATE

    override fun matches(
        location: String,
        configuration: NavigatorConfiguration
    ): Boolean {
        val baseURL = MainApplication().endpointModel.startURL
        return baseURL.toUri().host == location.toUri().host
    }

    override fun handle(
        location: String,
        configuration: NavigatorConfiguration,
        activity: HotwireActivity
    ) {
        // No-op
    }
}