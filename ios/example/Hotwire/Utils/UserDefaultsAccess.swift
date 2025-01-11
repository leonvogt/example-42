import Foundation

class UserDefaultsAccess {
  static let KEY_BASE_URL = "base_url"
  
  private init(){}
  
  static func setBaseURL(url: String) {
    UserDefaults.standard.set(url, forKey: KEY_BASE_URL)
  }
  
  static func getBaseURL() -> String {
    return UserDefaults.standard.string(forKey: KEY_BASE_URL) ?? ""
  }
}
