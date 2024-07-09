//
//  PatnerModel.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/9/24.
//

import Foundation


struct User: Codable {
    let name: Name
    let email: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct PatnerModel: Codable {
    let results: [User]
}
