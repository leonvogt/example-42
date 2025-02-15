import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

const PERMISSIONS = {
  CAMERA: "CAMERA",
}

// Connects to data-controller="native--permissions"
export default class extends BridgeComponent {
  static component = "permissions"

  biometricPrompt() {
    this.send("biometricPrompt", { title: "Authenticate to continue" }, (message) => {
      const result = message.data.success

      // Dispatches a "biometricResult" event with the result
      this.dispatch("biometricResult", { success: result })

      // If an action only needs to be taken if the biometric was successful,
      // we can directly listen for the "biometricSuccess" or "biometricFailure" events
      if (result) {
        this.dispatch("biometricSuccess")
      } else {
        this.dispatch("biometricFailure")
      }
    })
  }

  checkPermissions({ params: { permission } }) {
    const sanitizedPermission = PERMISSIONS[permission]
    if (!sanitizedPermission) {
      console.warn(`Unknown permission: ${permission}`)
      return
    }

    this.send("checkPermissions", { permission: sanitizedPermission }, (message) => {
      const granted = message.data.granted

      // Dispatches a "result" event with the granted status
      this.dispatch("result", { granted: granted })

      // If an action only needs to be taken if the permission is granted,
      // we can directly listen for the "granted" or "denied" events
      if (granted) {
        this.dispatch("granted")
      } else {
        this.dispatch("denied")
      }
    })
  }
}
