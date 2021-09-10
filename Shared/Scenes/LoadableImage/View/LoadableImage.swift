//
//  LoadableImage.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import SwiftUI
import ComposableArchitecture

struct LoadableImage<Placeholder: View, Empty: View>: View {
    let store: Store<LoadableImageState, LoadableImageAction>
    
    //MARK: - Private
    private let placeholder: Placeholder
    private let empty: Empty
    private var isTemplate: Bool
    
    init(store: Store<LoadableImageState, LoadableImageAction>,
         isTemplate: Bool = true,
         @ViewBuilder placeholder: () -> Placeholder,
         @ViewBuilder empty: () -> Empty) {
        
        self.placeholder = placeholder()
        self.empty = empty()
        self.store = store
        self.isTemplate = isTemplate
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.isLoading {
                    placeholder
                } else {
                    switch viewStore.result {
                    case let .success(image):
                        image
                            .renderingMode(isTemplate ? .template : .original)
                            .loadableImageModifier()

                    case .failure, .none:
                        empty
                    }
                }
            }
            .onAppear {
                viewStore.send(.startLoading)
            }
        }
    }
}

fileprivate extension Image {
    func loadableImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fill)
    }
}
