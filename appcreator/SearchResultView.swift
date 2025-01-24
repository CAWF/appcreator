import SwiftUI

struct SearchResultView: View {
    let searchResults: [PartySuggestion]
    @State private var scrollOffset: CGFloat = 0
    @State private var showScrollToTop = false
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(searchResults, id: \.id) { suggestion in
                        NavigationLink(destination: CompanyDetailView(company: suggestion)) {
                            ResultCard(suggestion: suggestion)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .id("TOP")
            }
            .overlay(
                GeometryReader { geometry -> Color in
                    let offset = geometry.frame(in: .named("scroll")).minY
                    DispatchQueue.main.async {
                        self.scrollOffset = offset
                        self.showScrollToTop = offset < -200
                    }
                    return Color.clear
                }
            )
            .overlay(
                Group {
                    if showScrollToTop {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        scrollProxy.scrollTo("TOP", anchor: .top)
                                    }
                                }) {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)
                                }
                                .padding()
                                .transition(.opacity)
                            }
                        }
                    }
                }
            )
            .coordinateSpace(name: "scroll")
        }
        .navigationBarTitle("Результаты поиска", displayMode: .inline)
    }
}

struct ResultCard: View {
    let suggestion: PartySuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(suggestion.value)
                .font(.headline)
                .lineLimit(2)
            
            Group {
                InfoRow(title: "ИНН:", value: suggestion.data.inn)
                InfoRow(title: "КПП:", value: suggestion.data.kpp ?? "Нет данных")
                InfoRow(title: "ОГРН:", value: suggestion.data.ogrn ?? "Нет данных")
                InfoRow(title: "Тип:", value: suggestion.data.type ?? "Нет данных")
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Text(value)
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchResultView(searchResults: [
                PartySuggestion(value: "ООО 'ТЕСТ'", unrestricted_value: "ООО 'ТЕСТ'", data: PartyData(kpp: "123456789", management: nil, branch_type: nil, branch_count: nil, type: "LEGAL", state: nil, opf: nil, name: Name(full_with_opf: "Общество с ограниченной ответственностью 'ТЕСТ'", short_with_opf: "ООО 'ТЕСТ'", full: nil, short: nil), inn: "1234567890", ogrn: "1234567890123", okpo: nil, okved: nil, ogrn_date: nil, address: nil)),
                PartySuggestion(value: "ИП Иванов", unrestricted_value: "ИП Иванов", data: PartyData(kpp: nil, management: nil, branch_type: nil, branch_count: nil, type: "INDIVIDUAL", state: nil, opf: nil, name: Name(full_with_opf: "Индивидуальный предприниматель Иванов", short_with_opf: "ИП Иванов", full: nil, short: nil), inn: "987654321", ogrn: "987654321098", okpo: nil, okved: nil, ogrn_date: nil, address: nil))
            ])
        }
    }
}


