//
//  PermissionsComponent.swift
//  example
//
//  Created by Leon on 02.02.2025.
//

import Foundation
import HotwireNative

final class PermissionsComponent: BridgeComponent {
    override class var name: String { "permissions" }
    
    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else {
            return
        }
        
        switch event {
        case .checkPermissions:
            handleCheckPermissions(message: message)
        }
    }

    private func handleCheckPermissions(message: Message) {
        // We always respond with true for now, so we can do the same permission check from the web as on Android
        // iOS asks for the respective permission as soon as it is needed.
        reply(to: Event.checkPermissions.rawValue, with: CheckPermissionsResponseData(granted: true))
    }
}

// MARK: Events

private extension PermissionsComponent {
    enum Event: String {
        case checkPermissions
    }
}

// MARK: Message data

private extension PermissionsComponent {
    struct MessageData: Decodable {
        let permission: String
    }
    
    // MARK: Response Structs
    struct CheckPermissionsResponseData: Encodable {
        let granted: Bool
    }
}
