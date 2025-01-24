import SwiftUI
import Combine
import AppMetricaCore

struct MainView: View {
    @State private var searchText = ""
    @State private var isSearchFieldInvalid = false
    @State private var showingResults = false
    @State private var isShowingMenu = false
    @State private var isEditing = false
    @State private var searchResults: [PartySuggestion] = []
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Основной контент
                ZStack {
                    Color(red: 240/255, green: 248/255, blue: 255/255)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("Проверка контрагентов")
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 200)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Искать по названию, по ИНН", text: $searchText)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: searchText) { _ in
                                    if isSearchFieldInvalid {
                                        isSearchFieldInvalid = false
                                    }
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSearchFieldInvalid ? Color.red : (isEditing ? Color.black : Color.clear), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            isEditing = true
                        }
                        
                        NavigationLink(
                            destination: SearchResultView(searchResults: searchResults),
                            isActive: $showingResults
                        ) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            handleSearch()
                        }) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 33/255, green: 150/255, blue: 243/255))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(PressableButtonStyle())
                        
                        Spacer()
                    }
                }
                
                // Боковое меню
                if isShowingMenu {
                    SideMenuView(isShowing: $isShowingMenu)
                        .transition(.opacity)
                }
            }
            .navigationBarItems(leading: Group {
                if !isShowingMenu {
                    Button(action: {
                        withAnimation {
                            isShowingMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.black)
                            .imageScale(.large)
                    }
                }
            })
            .onChange(of: searchResults) { newResults in
                if !newResults.isEmpty {
                    showingResults = true
                }
            }
        }
    }
    
    private func handleSearch() {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            withAnimation {
                isSearchFieldInvalid = true
            }
        } else {
            // Отслеживаем начало поиска
            AnalyticsService.shared.trackEvent(.searchStarted(query: searchText))
            
            DadataService.searchParty(query: searchText)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { response in
                    self.searchResults = response.suggestions
                    self.showingResults = !self.searchResults.isEmpty
                    
                    // Отслеживаем завершение поиска
                    AnalyticsService.shared.trackEvent(.searchCompleted(resultsCount: response.suggestions.count))
                })
                .store(in: &cancellables)
        }
        isEditing = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


