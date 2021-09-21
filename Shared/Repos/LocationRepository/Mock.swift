//
//  Mock.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/31/21.
//

import ComposableArchitecture
import ComposableCoreLocation
import Combine

extension LocationManager {
    
    public static var notDetermined: Self {
        return .unimplemented(
            authorizationStatus: {
                return .notDetermined
            }
        )
    }
}
