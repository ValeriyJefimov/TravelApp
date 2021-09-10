//
//  Search.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import Alamofire
import CoreLocation.CLLocation

struct SearchRequest: NetworkRequest {
    let query: String?
    let categoryId: String?
    
    let location: CLLocation

    let token: Token = liveToken
    let method: HTTPMethod = .get
    let headers: HTTPHeaders? = nil
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    var apiURL: URLConvertible { "/venues/search" }
    
    var params: Parameters? {
        var specParams: Parameters = [
            "ll" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "radius" : 1000,
        ]
        
        if let query = query {
            specParams["query"] = query
        } else if let categoryId = categoryId {
            specParams["categoryId"] = categoryId
        }
        
        return baseParametrs.merging(specParams, uniquingKeysWith: { f, _ in return f })
    }
    
    init(query: String, location: CLLocation) {
        self.query = query
        self.location = location
        self.categoryId = nil
    }
    
    init(categoryId: String, location: CLLocation) {
        self.query = nil
        self.location = location
        self.categoryId = categoryId
    }
}

extension SearchRequest {
    
}

struct SearchResponse: Decodable, Equatable {
    let venues: [Venue]
}

struct SearchResult: Decodable, Equatable {
    let meta: Meta?
    let response: SearchResponse?
}


