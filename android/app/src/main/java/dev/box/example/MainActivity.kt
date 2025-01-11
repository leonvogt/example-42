package dev.box.example

import android.os.Bundle
import dev.box.example.hotwire.viewmodels.EndpointModel
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration

class MainActivity : HotwireActivity() {
    lateinit var endpointModel: EndpointModel

    override fun onCreate(savedInstanceState: Bundle?) {
        this.endpointModel = (application as MainApplication).endpointModel

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "main",
            startLocation = endpointModel.startURL,
            navigatorHostId = R.id.main_nav_host
        )
    )
}