package dev.box.example.hotwire.bridgeComponents

import android.Manifest
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import dev.box.example.hotwire.utils.PermissionRequester
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

class PermissionsComponent(
    name: String,
    private val hotwireDelegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, hotwireDelegate) {

    private val fragment: Fragment
        get() = hotwireDelegate.destination.fragment

    override fun onReceive(message: Message) {
        when (message.event) {
            "checkPermissions" -> checkPermissions(message)
            else -> Log.w("PermissionsComponent", "Unknown event for message: $message")
        }
    }

    private fun checkPermissions(message: Message) {
        val data = message.data<MessageData>() ?: return

        val permission = Permissions.fromString(data.permission) ?: run {
            Log.w("PermissionsComponent", "Unknown permission: ${data.permission}")
            return
        }

        if (hasPermission(permission.permissionString)) {
            replyTo("checkPermissions", PermissionResultData(true))
        } else {
            (fragment as? PermissionRequester)?.requestPermission(permission.permissionString) { isGranted ->
                replyTo("checkPermissions", PermissionResultData(isGranted))
            } ?: Log.w("PermissionsComponent", "Fragment does not implement PermissionRequester")
        }
    }

    private fun hasPermission(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            fragment.requireContext(),
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    @Serializable
    data class MessageData(
        @SerialName("permission") val permission: String
    )

    @Serializable
    data class PermissionResultData(
        @SerialName("granted") val granted: Boolean
    )

    sealed class Permissions(val permissionString: String) {
        data object Camera : Permissions(Manifest.permission.CAMERA)

        companion object {
            fun fromString(permission: String): Permissions? {
                return when (permission) {
                    "CAMERA" -> Camera
                    else -> null
                }
            }
        }
    }
}