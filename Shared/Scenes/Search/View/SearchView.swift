//
//  SearchView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, LifecycleAction<SearchAction>>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                SearchBar(searchText: viewStore.binding(
                            get: \.searchText,
                            send: {
                                LifecycleAction.action(SearchAction.searchTextChanged($0))
                            }),
                          isFocused: true,
                          onCancel: {
                            viewStore.send(.action(.searchEnded))
                          })
                    .padding([.leading, .trailing], 15)
                if viewStore.results.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.largeTitle)
                        Text("No Results Found")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.title)
                        Spacer()
                    }
                    .gesture(
                        DragGesture().onEnded {
                                if 0 < $0.translation.height {
                                    withAnimation(.easeInOut(duration: 0.3)) { viewStore.send(.action(.searchEnded)) }
                                }
                            }
                    )
                }
                else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            Section(header: Color.clear.frame(height: 10)) { EmptyView() }
                            
                            ForEachStore(
                                self.store.scope(state: \.results,
                                                 action: {
                                                    LifecycleAction.action(SearchAction.venueRow(id:$0.0, action: $0.1))
                                                 }),
                                content: VenueRowView.init(store:)
                            )
                            
                            Section(header: Color.clear.frame(height: 110)) { EmptyView() }
                        }
                        .padding([.leading, .trailing], 15)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(store: Store.init(
                    initialState: SearchState
                        .init(
                            searchText: "",
                            results: [.mock]
                        ),
                    reducer: .empty,
                    environment: SearchEnvironment.mock)
        )
    }
}
