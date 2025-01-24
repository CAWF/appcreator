import SwiftUI
import AppMetricaCore

@main
struct appcreatorApp: App {
    init() {
        // Инициализация AppMetrica при запуске приложения
        AnalyticsService.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
