//
//  PatnerModel.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import Foundation

struct APIUser: Codable {
    let name: APIName?
    let email: String?
    let location: APILocation?
    let picture: APIPicture?
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case location
        case picture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(APIName.self, forKey: .name)
        email = try? container.decode(String.self, forKey: .email)
        location = try? container.decode(APILocation.self, forKey: .location)
        picture = try? container.decode(APIPicture.self, forKey: .picture)
    }
}

struct APIName: Codable {
    let title: String?
    let first: String?
    let last: String?
    
    init(title: String? = nil, first: String? = nil, last: String? = nil) {
        self.title = title
        self.first = first
        self.last = last
    }
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        first = try? container.decode(String.self, forKey: .first)
        last = try? container.decode(String.self, forKey: .last)
    }
}

struct APIPicture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
    init(large: String? = nil, medium: String? = nil, thumbnail: String? = nil) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        large = try? container.decode(String.self, forKey: .large)
        medium = try? container.decode(String.self, forKey: .medium)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
    }
}

struct PartnerModel: Codable {
    let results: [APIUser]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try? container.decode([APIUser].self, forKey: .results)
    }
}

struct APILocation: Codable {
    let street: Street?
    let city, state, country: String?
    
    enum CodingKeys: String, CodingKey {
        case street
        case city
        case state
        case country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try? container.decode(Street.self, forKey: .street)
        city = try? container.decode(String.self, forKey: .city)
        state = try? container.decode(String.self, forKey: .state)
        country = try? container.decode(String.self, forKey: .country)
    }
    
    func getLocation(location: APILocation?) -> String {
        var address = ""
        if let location = location {
            var numberString = ""
            if let number = location.street?.number {
                numberString = "\(number)"
            }
            address = "\(numberString), \(location.street?.name ?? ""), \(location.city ?? ""), \(location.state ?? "")"
        }
        return address
    }
    
}
struct Coordinates: Codable {
    let latitude, longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try? container.decode(String.self, forKey: .latitude)
        longitude = try? container.decode(String.self, forKey: .longitude)
    }
}

// MARK: - Street
struct Street: Codable {
    let number: Int?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case number
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try? container.decode(Int.self, forKey: .number)
        name = try? container.decode(String.self, forKey: .name)
    }
    
}
