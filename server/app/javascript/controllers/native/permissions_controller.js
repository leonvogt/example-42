import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

const PERMISSIONS = {
  CAMERA: "CAMERA",
}

// Connects to data-controller="native--permissions"
export default class extends BridgeComponent {
  static component = "permissions"

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
