//
//  Search.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import Alamofire
import ComposableCoreLocation

struct SearchRequest: NetworkRequest {
    let query: String?
    let categoryId: String?
    let radius: Double
    
    let location: Location

    let token: Token = liveToken
    let method: HTTPMethod = .get
    let headers: HTTPHeaders? = nil
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    var apiURL: URLConvertible { "/venues/search" }
    
    var params: Parameters? {
        var specParams: Parameters = [
            "ll" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "radius" : radius,
        ]
        
        if let query = query {
            specParams["query"] = query
        } else if let categoryId = categoryId {
            specParams["categoryId"] = categoryId
        }
        
        return baseParametrs.merging(specParams, uniquingKeysWith: { f, _ in return f })
    }
    
    init(query: String, location: Location) {
        self.query = query
        self.location = location
        self.categoryId = nil
        self.radius = 1000
    }
    
    init(categoryId: String, location: Location) {
        self.query = nil
        self.location = location
        self.categoryId = categoryId
        self.radius = 1000
    }
    
    init(region: MapRegion) {
        self.query = nil
        self.location = region.location
        self.categoryId = nil
        self.radius = region.radius
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


