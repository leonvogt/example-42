package dev.box.example.hotwire

import android.webkit.PermissionRequest
import dev.hotwire.core.turbo.session.Session
import dev.hotwire.core.turbo.webview.HotwireWebChromeClient

class CustomChromeClient(session: Session): HotwireWebChromeClient(session) {
    override fun onPermissionRequest(request: PermissionRequest?) {
        // If permission request is for camera access
        if (request?.resources?.contains(PermissionRequest.RESOURCE_VIDEO_CAPTURE) == true) {
            // Always grant permission
            // Depending on the android camera permission, the browser will still get a permission denied error if the user has not granted the permission
            request.grant(request.resources)
        }
    }
}