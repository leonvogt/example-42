package dev.box.example.hotwire.bridgeComponents

import android.util.Log
import androidx.fragment.app.Fragment
import dev.box.example.MainActivity
import dev.box.example.SharedPreferencesAccess
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class BaseURLComponent(
    name: String,
    private val hotwireDelegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, hotwireDelegate) {

    private val fragment: Fragment
        get() = hotwireDelegate.destination.fragment

    override fun onReceive(message: Message) {
        when (message.event) {
            "updateBaseURL" -> updateBaseURL(message)
            else -> Log.w("BaseURLComponent", "Unknown event for message: $message")
        }
    }

    private fun updateBaseURL(message: Message) {
        val data = message.data<MessageData>() ?: return
        val url = data.url

        // Save the new base URL to SharedPreferences
        SharedPreferencesAccess.setBaseURL(fragment.requireContext(), url)

        // Apply the new base URL and reset the navigators
        val mainActivity = fragment.activity as? MainActivity
        mainActivity?.endpointModel?.setBaseURL(url)
        mainActivity?.delegate?.resetNavigators()
    }

    @Serializable
    data class MessageData(
        @SerialName("url") val url: String
    )
}