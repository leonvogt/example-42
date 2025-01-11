import Foundation

enum Environment: String {
    case development, staging, production
}

extension Environment {
    static var current: Environment {
        if isAppStore {
            return .production
        } else if isTestFlight {
            return .staging
        }
        return .development
    }

    // From https://gist.github.com/SergLam/609e2dc76b9f321877f4fb7fe8e26fdf

    static var isTestFlight: Bool {
        if isSimulator {
            return false
        } else {
            if isAppStoreReceiptSandbox, !hasEmbeddedMobileProvision {
                return true
            } else {
                return false
            }
        }
    }

    static var isAppStore: Bool {
        if isSimulator {
            return false
        } else {
            if isAppStoreReceiptSandbox || hasEmbeddedMobileProvision {
                return false
            } else {
                return true
            }
        }
    }

    private static var hasEmbeddedMobileProvision: Bool {
        guard Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") == nil else {
            return true
        }
        return false
    }

    private static var isAppStoreReceiptSandbox: Bool {
        if isSimulator {
            return false
        } else {
            guard let url = Bundle.main.appStoreReceiptURL else {
                return false
            }
            guard url.lastPathComponent == "sandboxReceipt" else {
                return false
            }
            return true
        }
    }

    private static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

