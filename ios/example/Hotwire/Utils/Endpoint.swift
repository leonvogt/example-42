import Foundation

class Endpoint {
    static let instance = Endpoint()

    private var baseURL: URL {
        switch Environment.current {
        case .development:
            return URL(string: "http://192.168.1.245:3000")!
        case .staging:
            return URL(string: "https://stage.myapp.com")!
        case .production:
            return URL(string: "https://myapp.com")!
        }
    }

    private init() {} // Prevent external instantiation

    var start: URL {
        return baseURL.appendingPathComponent("/home")
    }
    
    var pathConfiguration: URL {
        return baseURL.appendingPathComponent("/api/mobile/v1/ios/path_configuration.json")
    }
}
