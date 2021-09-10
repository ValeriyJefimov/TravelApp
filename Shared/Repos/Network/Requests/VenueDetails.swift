//
//  Venues.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/25/21.
//

import Alamofire

struct VenueRequest: NetworkRequest {
    let id: String
    let token: Token = liveToken
    let method: HTTPMethod = .get
    let headers: HTTPHeaders? = nil
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    var params: Parameters? { baseParametrs }
    var apiURL: URLConvertible { "/venues/\(id)" }
}

struct VenueResponse: Decodable, Equatable {
    let venue: Venue
}

struct VenueResult: Decodable, Equatable {
    let meta: Meta?
    let response: VenueResponse?
}

