import { application } from "./application.js"

import { registerControllers } from "stimulus-vite-helpers"
const controllers = import.meta.glob("./**/*_controller.js", { eager: true })

registerControllers(application, controllers)
