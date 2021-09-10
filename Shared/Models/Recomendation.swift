//
//  Recommendation.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/18/21.
//

import Foundation

struct RecomndationGroup: Decodable, Equatable  {
    let items: [RecomndationItem]
}

struct RecomndationItem: Decodable, Equatable  {
    let venue: Recommendation
}

struct Recommendation: Equatable, Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    let id: String
    let name: String
}
