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
                        action: { viewStore.send(.action(.dissmiss)) },
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
                }
            }
            .padding([.leading, .trailing], 15)
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
