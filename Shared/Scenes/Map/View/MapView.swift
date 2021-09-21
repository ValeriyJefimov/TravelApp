//
//  MapView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/14/21.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: View {
    let store: Store<MapState, MapAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Map(coordinateRegion: viewStore.binding(get: { state in
                    MKCoordinateRegion(
                        center: .init(
                            latitude: state.currentRegion.location.coordinate.latitude,
                            longitude: state.currentRegion.location.coordinate.longitude
                        ),
                        span: .init(
                            latitudeDelta: state.currentRegion.span.latitudeDelta,
                            longitudeDelta: state.currentRegion.span.longitudeDelta
                        )
                    )
                }, send: {
                    return MapAction.regionChanged(.init(region: $0)) }),
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: viewStore.state.results
                ) { venue in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: venue.location.lat,
                            longitude: venue.location.lng
                        ), anchorPoint: CGPoint(x: 0.5, y: 1)) {
                        Image(viewStore.selectedVenue == venue ? "MapPinSelected" : "MapPin")
                            .onTapGesture {
                                viewStore.send(.venueSelected(venue))
                            }
                    }
                }
                .onAppear {
                    viewStore.send(.didAppear)
                }
                
                if viewStore.selectedVenue != nil {
                    VStack {
                        ZStack() {
                            RoundedRectangle(cornerRadius: 19)
                                .foregroundColor(.white)
                                .shadow(radius: 10, y: 5)
                            
                            VenueRowView(store: store
                                            .scope(
                                                state: \.selectedVenue!,
                                                action: MapAction.venue
                                            )
                            )
                            
                        }
                        .frame(height: 80)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
