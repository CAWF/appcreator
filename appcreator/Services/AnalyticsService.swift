import Foundation
import AppMetricaCore

enum AnalyticsEvent {
    case searchStarted(query: String)
    case searchCompleted(resultsCount: Int)
    case companySelected(inn: String)
    case menuOpened
    case menuItemSelected(item: String)
    
    var name: String {
        switch self {
        case .searchStarted: return "search_started"
        case .searchCompleted: return "search_completed"
        case .companySelected: return "company_selected"
        case .menuOpened: return "menu_opened"
        case .menuItemSelected: return "menu_item_selected"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchStarted(let query):
            return ["query": query]
        case .searchCompleted(let resultsCount):
            return ["results_count": resultsCount]
        case .companySelected(let inn):
            return ["company_inn": inn]
        case .menuOpened:
            return [:]
        case .menuItemSelected(let item):
            return ["item_name": item]
        }
    }
}


class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func configure() {
        // Замените YOUR_API_KEY на ваш реальный ключ AppMetrica
        if let configuration = AppMetricaConfiguration(apiKey: "d7d0de31-d185-460c-8f3e-91d271ea4b3a") {
            AppMetrica.activate(with: configuration)
        } else {
            print("Failed to create AppMetrica configuration")
        }
    }
    
    func trackEvent(_ event: AnalyticsEvent) {
        AppMetrica.reportEvent(name: event.name, parameters: event.parameters)
    }
}
