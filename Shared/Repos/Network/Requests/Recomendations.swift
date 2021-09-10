//
//  Recommendations.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/25/21.
//

import Alamofire
import CoreLocation

struct RecommendationsRequest: NetworkRequest {
    let location: CLLocation
    let token: Token = liveToken
    let method: HTTPMethod = .get
    let headers: HTTPHeaders? = nil
    let apiURL: URLConvertible = "/venues/explore"
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    
    var params: Parameters? {
        let specParams: Parameters = [
            "ll" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "radius" : 1000,
            "sortByPopularity" : "1",
            "limit": 5
        ]
        return baseParametrs.merging(specParams, uniquingKeysWith: { f, _ in return f })
    }
}

struct RecommendationsResponse: Decodable, Equatable {
    let groups: [RecomndationGroup]
}


struct RecommendationsResult: Decodable, Equatable {
    let meta: Meta?
    let response: RecommendationsResponse?
}

