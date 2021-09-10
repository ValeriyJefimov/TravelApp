//
//  TravelApp.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct TravelApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: .initial,
                    reducer: AppState.reducer,
                    environment: .init()
                )
            )
        }
    }
}
