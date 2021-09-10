//
//  Meta.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/20/21.
//

import Foundation

struct Meta: Codable, Equatable {
    let code: Int?
    let requestID: String?

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}
