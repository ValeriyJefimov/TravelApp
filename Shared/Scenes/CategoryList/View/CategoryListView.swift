//
//  CategoryListView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import SwiftUI
import ComposableArchitecture

struct CategoryListView: View {
    let store: Store<CategoryListState, CategoryListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Button(
                        action: { viewStore.send(.dissmiss) },
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
                        self.store.scope(state: \.venues,
                                         action: CategoryListAction.venueRow(id:action:)),
                        content: VenueRowView.init(store:)
                    )
                }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}


struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(
            store: Store<CategoryListState, CategoryListAction>.init(
                initialState: .mock,
                reducer: categoryListReducer,
                environment: .init(networkRepo: .live, mainQueue: .main)
            )
        )
    }
}
