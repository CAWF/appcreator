import SwiftUI
import AppMetricaCore

struct CompanyDetailView: View {
    let company: PartySuggestion
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(company.value)
                    .font(.title)
                    .fontWeight(.bold)
            
                Group {
                    detailRow(title: "Тип", value: company.data.type)
                    detailRow(title: "Полное наименование", value: company.data.name.full_with_opf)
                    detailRow(title: "Краткое наименование", value: company.data.name.short_with_opf)
                    detailRow(title: "ИНН", value: company.data.inn)
                    detailRow(title: "КПП", value: company.data.kpp)
                    detailRow(title: "ОГРН", value: company.data.ogrn)
                    if let ogrn_date = company.data.ogrn_date {
                        detailRow(title: "Дата регистрации", value: formatDate(company.data.ogrn_date))
                    }
                    if let management = company.data.management {
                        detailRow(title: "Руководитель", value: management.name)
                        detailRow(title: "Должность", value: management.post)
                    }
                    detailRow(title: "Статус", value: company.data.state?.status)
                    detailRow(title: "Адрес", value: company.data.address?.value)
                    detailRow(title: "ОКПО", value: company.data.okpo)
                    detailRow(title: "ОКВЭД", value: company.data.okved)
                }
            }
            .padding()
        }
        .navigationBarTitle("Детали компании", displayMode: .inline)
        .onAppear {
            // Отслеживаем просмотр деталей компании
            AnalyticsService.shared.trackEvent(.companySelected(inn: company.data.inn))
        }
    }
    
    private func detailRow(title: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value ?? "Нет данных")
                .font(.body)
        }
    }
    
    private func formatDate(_ timestamp: Int64?) -> String {
        guard let timestamp = timestamp else { return "Нет данных" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

struct CompanyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CompanyDetailView(company: PartySuggestion(value: "ООО 'ТЕСТ'", unrestricted_value: "ООО 'ТЕСТ'", data: PartyData(kpp: "123456789", management: Management(name: "Иванов Иван Иванович", post: "Генеральный директор"), branch_type: nil, branch_count: nil, type: "LEGAL", state: CompanyState(status: "ACTIVE", actuality_date: 1609459200000, registration_date: 1577836800000), opf: nil, name: Name(full_with_opf: "Общество с ограниченной ответственностью 'ТЕСТ'", short_with_opf: "ООО 'ТЕСТ'", full: nil, short: nil), inn: "1234567890", ogrn: "1234567890123", okpo: "12345678", okved: "62.01", ogrn_date: 1577836800000, address: Address(value: "г Москва, ул Тестовая, д 1", unrestricted_value: "г Москва, ул Тестовая, д 1", data: nil))))
        }
    }
}


