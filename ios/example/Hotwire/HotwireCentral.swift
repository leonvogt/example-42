import WebKit
import HotwireNative

class HotwireCentral {
    static let instance = HotwireCentral()
    let sharedProcessPool = WKProcessPool()
    
    var navigator: Navigator!
    weak var window: UIWindow?
    
    private init() {
        configureHotwire()
        self.navigator = Navigator(delegate: self)
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

extension HotwireCentral : NavigatorDelegate {
    func handle(proposal: VisitProposal) -> ProposalResult {
        if proposal.popUntilHandling {
            if let components = URLComponents(url: proposal.url, resolvingAgainstBaseURL: false),
               let queryItem = components.queryItems?.first(where: { $0.name == "url" }),
               let desiredURL = queryItem.value {
                
                let currentURLsOnTheStack = navigator.activeNavigationController.viewControllers.compactMap { controller in
                    (controller as? VisitableViewController)?.visitableURL
                } // => currentURLsOnTheStack: [http://192.168.1.245:3000/home, http://192.168.1.245:3000/articles/test_1, http://192.168.1.245:3000/articles/test_2, http://192.168.1.245:3000/articles/test_4]
                
                // Find the first matching URL starting from the end of the array
                if let index = currentURLsOnTheStack.lastIndex(where: { url in
                    guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return false }
                    return urlComponents.path == desiredURL
                }) {
                    // How many times do we need to pop, to reach the desired controller
                    let popCount = currentURLsOnTheStack.count - index - 1
                    for _ in 0..<popCount {
                        navigator.pop()
                    }
    
                    return .reject
                }

                print("Didn't find \(desiredURL) on the stack. Navigating to it")
                navigator.pop()
                let webViewController = HotwireWebViewController(url: Endpoint.instance.endpointFor(relativURL: desiredURL))
                return .acceptCustom(webViewController)
            }
            
            print("Failed to extract URL query parameter")
            return .accept
        } else {
            return .accept
        }
    }
}
