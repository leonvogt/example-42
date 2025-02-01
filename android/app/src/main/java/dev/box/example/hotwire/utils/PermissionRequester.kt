package dev.box.example.hotwire.utils

interface PermissionRequester {
    fun requestPermission(permission: String, callback: (Boolean) -> Unit)
}