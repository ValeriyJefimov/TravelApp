//
//  CategoryListView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import SwiftUI
import ComposableArchitecture

struct CategoryListView: View {
    let store: Store<CategoryListState, LifecycleAction<CategoryListAction>>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Button(
                        action: { viewStore.send(.action(.dissmiss), animation: .easeInOut) },
                        label: {
                            Image(systemName: "arrow.left")
                                .frame(width: 55, height: 55)
                                .font(.body.bold())
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.white).clipShape(Circle())
                        }
                    )
                    Text(viewStore.name)
                        .font(.title)
                        .bold()
                }
                .padding([.leading, .trailing], 15)
                ScrollView {
                    LazyVStack {
                        ForEachStore(
                            self.store.scope(
                                state: \.venues,
                                action: {
                                    .action(CategoryListAction.venueRow(id: $0.0, action: $0.1))
                                })
                        ) { rowStore in
                            VenueRowView(store: rowStore)
                        }
                        Section(header: Color.clear.frame(height: 110)) { EmptyView() }
                    }
                    .padding([.top, .leading, .trailing], 15)
                }
            }
            .onAppear {
                viewStore.send(.action(.loadCategories))
            }
        }
    }
}


struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(
            store: .init(
                initialState: .mock,
                reducer: .empty,
                environment: CategoryListEnvironment(
                    networkRepo: .live,
                    mainQueue: .main
                )
            )
        )
    }
}
