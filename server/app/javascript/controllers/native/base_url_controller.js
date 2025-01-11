import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

// Connects to data-controller="native--base-url"
export default class extends BridgeComponent {
  static component = "base-url"

  updateBaseURL({ params: { url } }) {
    this.send("updateBaseURL", { url })
  }
}
