import UIKit

struct Appearance {
    static func configure() {
        configureNavigationBar()
    }

    private static func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(.black)
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Color from navbar title
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white // Color from menu and backbutton
    }
}
