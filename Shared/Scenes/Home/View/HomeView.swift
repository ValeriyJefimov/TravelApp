//
//  HomeView.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import SwiftUI
import ComposableArchitecture
import ImagePickerView
import UIKit.UIImage

struct HomeView: View {
    
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Hi \(viewStore.user.name)!")
                            .foregroundColor(.mainCyan)
                            .font(.headline)
                            .bold()
                        Spacer()
                        Button {
                            viewStore.send(.presentOptionSheet)
                        } label: {
                            if let profileImage = viewStore.user.profileImage {
                                Image(uiImage: profileImage)
                                    .profileImageModifier(padding: .init())
                                
                            } else {
                                Image(systemName: "person.fill")
                                    .profileImageModifier(padding: .init(
                                                            top: 15,
                                                            leading: 10,
                                                            bottom: 5,
                                                            trailing: 10))
                            }
                        }
                    }
                    .padding([.leading, .trailing], 15)
                    .frame(height: 80)
                    .offset(y: 10)
                    
                    Text("Discover")
                        .font(.system(size: 33, weight: .heavy))
                        .frame(height: 40)
                        .padding([.leading, .trailing], 15)

                    SearchBar(
                        searchText: .constant(""),
                        isFocused: false
                    )
                    .padding([.leading, .trailing], 15)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) { viewStore.send(.startSearch) }
                    }
                    
//                    ScrollView(axes: .horizontal, showsIndicators: false) {
//                        LazyHGrid(rows: [GridItem(.fixed(143))]) {
//                            ForEach(viewStore.categories) { category in
//                                CategoryView(title: category.shortName, url: category.url) {
//                                    viewStore.send(.showCategory(category))
//                                }
//                            }
//                        }
//                        .padding(20)
//                    }
//                    .padding([.leading, .trailing], 15)
//                    .padding(-20)
//
//                    ScrollView(axes: .horizontal, showsIndicators: false) {
//                        LazyHGrid(rows: [GridItem(.fixed(246))]) {
//                            ForEach(viewStore.recommendations) { rec in
//                                RecommendationView(recommendation: rec)
//                            }
//                        }
//                        .padding(20)
//                    }
//                    .padding([.leading, .trailing], 15)
//                    .padding(-20)
//
//                    Spacer(minLength: 54)
                }
//                .modalLink(
//                    isPresented: viewStore.binding(
//                        get: { $0.categoryList != nil},
//                        send: { $0 ? .showCategory(.mock) : .dissmissCategory }
//                    ),
//                    linkType: ModalTransition.fullScreenModal
//                ) {
//
//                    IfLetStore(self.store.scope(
//                        state: \.categoryList,
//                        action: HomeAction.category
//                    )) { detailStore in
//                        CategoryListView(store: detailStore)
//                    }
//                }
                .modalLink(
                    isPresented: .constant(viewStore.searchState != nil),
                    linkType: ModalTransition.cover(offset: 140)
                ) {
                    IfLetStore(
                        self.store.scope(state: \.searchState, action: HomeAction.search),
                        then: SearchView.init(store:)
                    )
                }
                .scrollOnOverflow()
                .actionSheet(self.store.scope(state: \.optionSheet), dismiss: .dissmissOptionSheet)
                .sheet(isPresented: viewStore.binding(
                    get: \.showImagePicker,
                    send: HomeAction.dissmissImagePicker
                )) {
                    ImagePickerView(sourceType: .photoLibrary) { viewStore.send(.addPhoto($0)) }
                }
                .onAppear {
                    viewStore.send(.downloadCategories)
                    // viewStore.send(.requestLocationPermission)
                }
                
                if viewStore.isDataFetching { FullscreenProgressView() }
            }
        }
    }
}

fileprivate extension Image {
    func profileImageModifier(padding: EdgeInsets) -> some View {
        self
            .resizable()
            .padding(padding)
            .foregroundColor(.white)
            .background(Color.gray)
            .clipShape(Circle())
            .frame(width: 66, height: 66)
            .overlay(Circle().stroke(Color.white, lineWidth: 10))
            .overlay(Circle().stroke(Color.mainCyan, lineWidth: 2))
    }
}

struct CategoryView: View {
    
    var title: String
    var url: URL?
    var onSelect: () -> Void
    
    var body: some View {
        
        ZStack() {
            Rectangle()
                .cornerRadius(20)
                .foregroundColor(.white)
                .shadow(radius: 10)
            VStack {
                LoadableImage(store: createLoadableImageStore(url)) {
                    ProgressView()
                } empty: {
                    Image(systemName: "ticket")
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(.degrees(-45))
                }
                .foregroundColor(.mainCyan)
                .background(Color.mainCyan.opacity(0.3))
                .clipShape(Circle())
                .frame(width: 58, height: 58)
                
                
                Text(title)
                    .font(.caption2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 33)
            }
            
        }
        .onTapGesture(perform: onSelect)
        .frame(width: 90, height: 133)
    }
}

struct RecommendationView: View {
    
    var recommendation: Venue
    
    var body: some View {
        
        ZStack() {
            GeometryReader { reader in
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                VStack {
                    LoadableImage(store: createLoadableImageStore(recommendation.bestPhotoUrl),
                                  isTemplate: false) {
                        ProgressView()
                    } empty: {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: reader.size.width,
                           height: reader.size.height * 0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        Text(recommendation.name)
                            .font(.callout)
                            .bold()
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        Button(
                            action: {},
                            label: {
                                Image(systemName: "heart")
                                    .foregroundColor(.gray)
                            }
                        )
                    }
                    .padding([.leading, .trailing, .top])
                    
                    HStack {
                        StarsView(rating: CGFloat(recommendation.rating ?? 0))
                            .frame(width: 95)
                        Spacer()
                    }
                    .padding([.leading, .trailing])
                    
                }
            }
        }
        .frame(width: 194, height: 226)
    }
}

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int = 10
    var ratingCount: Int = 5
    
    var body: some View {
        let stars = HStack(spacing: 5) {
            ForEach(0..<ratingCount) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store:
                    Store(
                        initialState: .init(
                            user: User(name: "Vasia",
                                       pass: "",
                                       email: ""),
                            categories: [.mock],
                            recommendations: [.mock],
                            isDataFetching: false,
                            searchState: .live
                        ),
                        reducer: homeReducer,
                        environment: HomeEnvironment(
                            authRepo: .mock,
                            networkRepo: .live,
                            locationRepo: .notDetermined
                        )
                    )
        )
    }
}

struct FullscreenProgressView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white.opacity(0.7))
            ProgressView()
        }
        .ignoresSafeArea()
    }
}
