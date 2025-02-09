import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets = ["video"]

  startCamera() {
    navigator.mediaDevices.getUserMedia(this.videoOptions).then((mediaStream) => {
      this.videoTarget.srcObject = mediaStream
      this.videoTarget.onloadedmetadata = () => {
        this.videoTarget.play()
      }
    })
  }

  get videoOptions() {
    return {
      audio: false,
      video: true,
    }
  }
}
