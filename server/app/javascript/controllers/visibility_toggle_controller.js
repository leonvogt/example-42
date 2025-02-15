import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visibility-toggle"
export default class extends Controller {
  static targets = ["elementToToggle"]

  toggle() {
    this.elementToToggleTargets.forEach((element) => element.classList.toggle("d-none"))
  }

  show() {
    this.elementToToggleTargets.forEach((element) => element.classList.remove("d-none"))
  }

  hide() {
    this.elementToToggleTargets.forEach((element) => element.classList.add("d-none"))
  }
}
