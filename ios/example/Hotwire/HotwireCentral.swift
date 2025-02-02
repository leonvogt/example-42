import WebKit
import HotwireNative

class HotwireCentral {
    static let instance = HotwireCentral()
    let sharedProcessPool = WKProcessPool()
    
    var navigator: Navigator!
    weak var window: UIWindow?
    
    private init() {
        configureHotwire()
        self.navigator = Navigator()
        self.navigator.webkitUIDelegate = CustomWKUIController()
    }
    
    private func configureHotwire() {
        // User agent
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let iosVersion = UIDevice.current.systemVersion
        let userAgentPrefix = "app_version: \(versionNumber); ios_version: \(iosVersion)"
        Hotwire.config.applicationUserAgentPrefix = userAgentPrefix
        
        // Path Configuration
        Hotwire.loadPathConfiguration(from: [
            .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!),
            .server(Endpoint.instance.pathConfiguration)
        ])
        
        // Bridge Components
        Hotwire.registerBridgeComponents([
            BaseURLComponent.self,
            PermissionsComponent.self
        ])
        
        // Generic config
        // Hotwire.config.debugLoggingEnabled = true
        Hotwire.config.backButtonDisplayMode = .minimal
        
        // WebView config
        Hotwire.config.makeCustomWebView = { configuration in
            configuration.processPool = self.sharedProcessPool
            configuration.defaultWebpagePreferences?.preferredContentMode = .mobile
            configuration.allowsInlineMediaPlayback = true // Allow camerafeed inside the WebView
            
            let webView = WKWebView(frame: .zero, configuration: configuration)
            if #available(iOS 16.4, *) {
                webView.isInspectable = true // To inspect the WebView through Safari
            }

            // Add WebView to the Bridge
            Bridge.initialize(webView)

            // Prevent link preview (long press on a link)
            webView.allowsLinkPreview = false

            return webView
        }
    }
    
    func didStart(url: URL?, window: UIWindow?) {
        self.window = window
        self.window?.rootViewController = HotwireCentral.instance.navigator.rootViewController
    
        navigator.route(Endpoint.instance.start)
        Appearance.configure()
    }
    
    func resetNavigator() {
        Hotwire.loadPathConfiguration(from: [
            .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!),
            .server(Endpoint.instance.pathConfiguration)
        ])
        self.navigator = Navigator()
        if let window = window {
            window.rootViewController = self.navigator.rootViewController
        }
        
        navigator.route(Endpoint.instance.start)
    }
}


