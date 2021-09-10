//
//  SearchView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                SearchBar(searchText: viewStore.binding(
                            get: \.searchText,
                            send: SearchAction.searchTextChanged),
                          isFocused: true
                )
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
                        DragGesture()
                            .onChanged {
                                if 0 < $0.translation.height {
                                    withAnimation(.easeInOut(duration: 0.3)) { viewStore.send(.searchEnded) }
                                }
                            }
                    )
                }
                else {
                    ScrollView(showsIndicators: false,
                               offsetChanged: {
                                guard $0.y > 30 else { return }
                                withAnimation(.easeInOut(duration: 0.3)) { viewStore.send(.searchEnded) }
                               }
                    ) {
                        LazyVStack {
                            Section(header: Color.clear.frame(height: 10)) { EmptyView() }
                            
                            ForEachStore(
                                self.store.scope(state: \.results,
                                                 action: SearchAction.venueRow(id:action:)),
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

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct ScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: Content

    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    
    var body: some View {
           SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
               GeometryReader { geometry in
                   Color.clear.preference(
                       key: ScrollOffsetPreferenceKey.self,
                       value: geometry.frame(in: .named("scrollView")).origin
                   )
               }.frame(width: 0, height: 0)
               content
           }
           .coordinateSpace(name: "scrollView")
           .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
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
                    reducer: searchReducer,
                    environment: .mock)
        )
    }
}
