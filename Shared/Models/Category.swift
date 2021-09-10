//
//  Category.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import Foundation

struct Category: Equatable, Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, shortName, icon, categories
    }
    
    let id: String
    let url: URL?
    let shortName: String
    let categories: [Category]
}

extension Category {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.shortName = try container.decode(String.self, forKey: .shortName)
        self.categories = try container.decode([Category].self, forKey: .categories)
        let icon = try container.decode([String: String].self, forKey: .icon)
        if let preffix = icon["prefix"],
           let suffix = icon["suffix"] {
            self.url = URL(string: preffix + "88" + suffix)
        } else {
            self.url = nil
        }
    }
}

extension Category {
    static let mock = Category(
        id: "4bf58dd8d48988d1a5941735",
        url: URL(string: "https://ss3.4sqi.net/img/categories_v2/education/lab_88.png"),
        shortName: "College Auditoriums",
        categories: []
    )
}
