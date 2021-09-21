//
//  VenueRowView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/6/21.
//

import SwiftUI
import ComposableArchitecture

struct VenueRowView: View {
    let store: Store<Venue, VenueRowAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack() {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(radius: 10, y: 5)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewStore.name)
                            .font(.body)
                            .bold()
                        
                        Text(viewStore.categories.first?.name ?? "Category")
                            .font(.callout)
                    }
                    Spacer()
                    HStack {
                        Text(distanceString(for: viewStore.location.distance))
                            .bold()
                            .foregroundColor(.mainCyan)
                        
                        Image(systemName: "chevron.forward")
                            .frame(width: 24, height: 24)
                            .font(.body.bold())
                            .background(Color.mainCyan.opacity(0.3))
                            .foregroundColor(.mainCyan).clipShape(Circle())
                    }
                }
                .padding()
            }
            .onTapGesture {
                viewStore.send(.didSelect(viewStore.state))
            }
        }
    }
}

private let distanceFormatter: MeasurementFormatter = {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = .providedUnit
    return formatter
}()

func distanceString(for distance: Double) -> String {
    distanceFormatter.unitOptions = .providedUnit
    let measurement = Measurement(value: distance, unit: UnitLength.meters)
    return distanceFormatter.string(from: measurement)
}

struct VenueRowView_Previews: PreviewProvider {
    static var previews: some View {
        VenueRowView(store: Store<Venue, VenueRowAction>.init(
                        initialState: .mock,
                        reducer: venueRowReducer,
                        environment: .init())
        )
    }
}
