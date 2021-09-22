//
//  AppView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        return WithViewStore(self.store) { viewStore in
            VStack {
                if viewStore.isUserLogged {
                    ZStack {
                        switch viewStore.selectedTab {
                        case .home:
                            HomeView(
                                store: store
                                    .scope(
                                        state: \.homeState!,
                                        action: AppAction.home
                                    )
                            ).ignoresSafeArea(edges: .bottom)
                            
                        case .favorites:
                            Rectangle()
                                .foregroundColor(.red)
                            
                        case .map:
                           MapView(store: store
                                    .scope(
                                        state: \.mapState,
                                        action: AppAction.map
                                    ))
                            .ignoresSafeArea(edges: .bottom)
                        }
                        
                        VStack {
                            Spacer()
                            
                            AppTabbar(selectedTab: viewStore.binding(
                                get: \.selectedTab,
                                send: AppAction.changeSelectedTab
                            ))
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)

                    }
                    
                } else {
                    AuthView(
                        store: store.scope(
                            state: \.authState!,
                            action: { .auth($0) }
                        )
                    )
                }
            }.onAppear {
                viewStore.send(.appDidFinishLaunching)
            }.alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDissapears
            )
        }
    }
}

struct AppTabbar: View {
    
    @Binding var selectedTab: AppTab
    
    var body: some View {
        ZStack() {
            Rectangle()
                .cornerRadius(39)
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            HStack() {
                TabbarButton(image: Image(systemName: "house"),
                             isSelected: selectedTab == .home,
                             action: { selectedTab = .home })
                
                Spacer()
                
                TabbarButton(image: Image(systemName: "map"),
                             isSelected: selectedTab == .map,
                             action: { selectedTab = .map })
                
                Spacer()
                
                TabbarButton(image: Image(systemName: "heart"),
                             isSelected: selectedTab == .favorites,
                             action: { selectedTab = .favorites })
            }
        }
        .frame(height: 54)
        .padding([.leading, .trailing, .bottom])
        
    }
}

struct TabbarButton: View {
    let image: Image
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }, label: {
            image
        })
        .frame(width: 44, height: 44)
        .foregroundColor(isSelected ? .white: .gray)
        .background(isSelected ? Color.mainCyan: .white)
        .clipShape(Circle())
        .padding([.leading, .trailing], 20)
        
        
    }
}
