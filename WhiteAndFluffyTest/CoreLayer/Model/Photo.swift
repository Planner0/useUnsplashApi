//
//  Photo.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 16.10.2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let urls: Urls
    let user: User
    let location: Location
    let downloads: Int

//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case description
//        case urls
//        case user, location, downloads
//    }
}

// MARK: - Location
struct Location: Codable {
    let name, city, country: String?
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
    var thumbUrl: URL {
        return URL(string: thumb)!
    }

//    enum CodingKeys: String, CodingKey {
//        case raw, full, regular, small, thumb
//        case smallS3 = "small_s3"
//    }
}

// MARK: - User
struct User: Codable {
    let id: String
    let username, name: String

//    enum CodingKeys: String, CodingKey {
//        case id
//        case username, name
//
//    }
}
