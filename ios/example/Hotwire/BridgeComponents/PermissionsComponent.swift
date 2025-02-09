import Foundation
import HotwireNative
import AVFoundation

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
        guard let data: MessageData = message.data() else { return }
        let permission = Permissions.fromString(data.permission)
        
        switch permission {
        case .camera:
            handleCameraPermission(message: message)
        case .unknown:
            print("PermissionsComponent - Unknown permission: \(permission)")
        }
    }

    private func handleCameraPermission(message: Message) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            reply(to: Event.checkPermissions.rawValue, with: PermissionResultData(granted: true))
        case .denied, .restricted:
            reply(to: Event.checkPermissions.rawValue, with: PermissionResultData(granted: false))
        case .notDetermined:
            // Camera access has not been requested yet
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.reply(to: Event.checkPermissions.rawValue, with: PermissionResultData(granted: granted))
                }
            }
        @unknown default:
            reply(to: Event.checkPermissions.rawValue, with: PermissionResultData(granted: false))
        }
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
    
    struct PermissionResultData: Encodable {
        let granted: Bool
    }
    
    enum Permissions {
        case camera
        case unknown
        
        static func fromString(_ permission: String) -> Permissions {
            switch permission.lowercased() {
            case "camera":
                return .camera
            default:
                return .unknown
            }
        }
    }
}
