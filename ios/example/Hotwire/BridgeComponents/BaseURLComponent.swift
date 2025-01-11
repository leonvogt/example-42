import HotwireNative

final class BaseURLComponent: BridgeComponent {
    override class var name: String { "base-url" }
    
    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else {
            return
        }
        
        switch event {
        case .updateBaseURL:
            handleupdateBaseURL(message: message)
        }
    }
    
    // MARK: Private
    
    private func handleupdateBaseURL(message: Message) {
        guard let data: MessageData = message.data() else { return }
        let url = data.url
        UserDefaultsAccess.setBaseURL(url: url)
        HotwireCentral.instance.resetNavigator()
    }
}

// MARK: Events

private extension BaseURLComponent {
    enum Event: String {
        case updateBaseURL
    }
}

// MARK: Message data

private extension BaseURLComponent {
    struct MessageData: Decodable {
        let url: String
    }
}
