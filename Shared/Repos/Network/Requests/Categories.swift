//
//  Categories.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/19/21.
//

import Alamofire

struct CategoriesRequest: NetworkRequest {
    var token: Token = liveToken
    let method: HTTPMethod = .get
    var headers: HTTPHeaders? = nil
    let apiURL: URLConvertible = "/venues/categories"
    let encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    
    var params: Parameters? {
        return baseParametrs
    }
}

struct CategoriesResponse: Decodable, Equatable {
    let categories: [Category]
}

struct CategoriesResult: Decodable, Equatable {
    let meta: Meta?
    let response: CategoriesResponse?
}
