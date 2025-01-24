import SwiftUI
import AppMetricaCore

struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            // Затемненный фон
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
            
            // Меню
            HStack {
                VStack(spacing: 0) {
                    // Хедер с кнопкой закрытия и заголовком
                    HStack {
                        Button(action: {
                            withAnimation {
                                isShowing = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .imageScale(.large)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Text("ПРОФИЛЬ")
                            .font(.system(size: 17, weight: .bold))
                        
                        Spacer()
                        
                        // Пустое пространство для выравнивания заголовка по центру
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.top, 50)
                    
                    // Элементы меню
                    VStack(spacing: 16) {
                        MenuItemView(
                            icon: "doc.text",
                            title: "Политика конфиденциальности",
                            action: {
                                AnalyticsService.shared.trackEvent(.menuItemSelected(item: "privacy_policy"))
                                // Действие для политики конфиденциальности
                            }
                        )
                        
                        MenuItemView(
                            icon: "message",
                            title: "Написать в поддержку",
                            action: {
                                AnalyticsService.shared.trackEvent(.menuItemSelected(item: "support"))
                                // Действие для поддержки
                            }
                        )
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .background(Color(red: 240/255, green: 248/255, blue: 255/255))
                .edgesIgnoringSafeArea(.vertical)
                .onAppear {
                    AnalyticsService.shared.trackEvent(.menuOpened)
                }
                
                Spacer()
            }
            .offset(x: isShowing ? 0 : -UIScreen.main.bounds.width)
        }
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(red: 33/255, green: 150/255, blue: 243/255))
                    .imageScale(.large)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .imageScale(.small)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true))
    }
}


