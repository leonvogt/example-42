package dev.box.example.hotwire.fragment

import android.os.Bundle
import android.view.MenuItem
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import dev.box.example.R
import dev.box.example.hotwire.CustomChromeClient
import dev.box.example.hotwire.utils.PermissionRequester
import dev.hotwire.core.turbo.webview.HotwireWebChromeClient
import dev.hotwire.navigation.destinations.HotwireDestinationDeepLink
import dev.hotwire.navigation.fragments.HotwireWebFragment

@HotwireDestinationDeepLink(uri = "hotwire://fragment/web")
open class WebFragment : HotwireWebFragment(), PermissionRequester {
    private var permissionCallback: ((Boolean) -> Unit)? = null

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        permissionCallback?.invoke(isGranted)
        permissionCallback = null
    }

    override fun requestPermission(permission: String, callback: (Boolean) -> Unit) {
        permissionCallback = callback
        requestPermissionLauncher.launch(permission)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupMenuProgressSpinner()
    }

    override fun onFormSubmissionStarted(location: String) {
        menuProgress?.isVisible = true
    }

    override fun onFormSubmissionFinished(location: String) {
        menuProgress?.isVisible = false
    }

    override fun createWebChromeClient(): HotwireWebChromeClient {
        return CustomChromeClient(navigator.session)
    }

    private fun setupMenuProgressSpinner() {
        toolbarForNavigation()?.inflateMenu(R.menu.web)
    }

    private val menuProgress: MenuItem?
        get() = toolbarForNavigation()?.menu?.findItem(R.id.menu_progress)
}
