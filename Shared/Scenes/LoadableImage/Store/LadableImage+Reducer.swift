//
//  LoadableImage+Reducer.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import ComposableArchitecture

let loadableImageReducer = Reducer<LoadableImageState, LoadableImageAction, LoadableImageEnvironment> { state, action, env in
    switch action {
    case .startLoading:
        state.isLoading = true
        return env
            .loader(state.url)
            .catchToEffect()
            .map(LoadableImageAction.loaded)
        
    case .loading:
        state.isLoading = true
        return .none
        
    case let .loaded(result):
        state.isLoading = false
        state.result = result
        return .none
    }
}

var createLoadableImageStore: (URL?) -> Store<LoadableImageState, LoadableImageAction> = { url in
    return .init(
        initialState: LoadableImageState(url: url),
        reducer: loadableImageReducer,
        environment: LoadableImageEnvironment.live
    )
}
