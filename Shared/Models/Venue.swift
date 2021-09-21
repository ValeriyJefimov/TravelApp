//
//  Venue.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/25/21.
//

import Foundation

fileprivate struct BestPhoto: Decodable {
    let id: String
    let prefix: String
    let suffix: String
}

struct Venue: Equatable, Identifiable, Decodable {
    
    struct Category: Identifiable, Decodable, Equatable {
        let id: String
        let name: String
    }
    
    struct Location: Decodable, Equatable {
        let address: String?
        let lat: Double
        let lng: Double
        let distance: Double
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, bestPhoto, categories, location
    }
    
    let id: String
    let name: String
    let rating: Double?
    let bestPhotoUrl: URL?
    let categories: [Category]
    let location: Location
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.rating = try? container.decode(Double.self, forKey: .rating)
        self.categories = (try? container.decode([Category].self, forKey: .categories)) ?? []
        self.location = try container.decode(Location.self, forKey: .location)
        if let photo = try? container.decode(BestPhoto.self, forKey: .bestPhoto) {
            self.bestPhotoUrl = URL(string: photo.prefix + "300x200" + photo.suffix)
        } else {
            self.bestPhotoUrl = nil
        }
    }
    
    init(id: String, name: String, rating: Double, bestPhotoUrl: URL?,
         categories: [Category] = [],
         location: Location) {
        self.id = id
        self.name = name
        self.rating = rating
        self.bestPhotoUrl = bestPhotoUrl
        self.categories = categories
        self.location = location
    }
}

extension Venue {
    static var mock: Venue =
        Venue(id: UUID().uuidString,
              name: "Japan Center",
              rating: 9.7,
              bestPhotoUrl: URL(string: "https://refactoring.guru/images/patterns/content/observer/observer-3x.png"), location: Venue.Location(address: "350-352 Oxford St", lat: 51.5145908608644, lng: -0.14824202162219546, distance: 1130))
}
