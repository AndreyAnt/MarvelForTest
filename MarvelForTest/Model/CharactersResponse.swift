//
//  CharactersResponse.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation

// MARK: - CharactersResponse
struct CharactersResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int
    let characters: [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case characters = "results"
    }
}

// MARK: - Result
struct MarvelCharacter: Codable {
    let id: Int
    let name, resultDescription: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: URIResponse
    let stories: URIResponse
    let events: URIResponse
    let urls: [URLElement]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - ComicsResponse
struct URIResponse: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

// MARK: - Item
struct Item: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    var url: URL? {
        let securePath = path.replacingOccurrences(of: "http", with: "https")
        let urlString = securePath + "." + thumbnailExtension.rawValue
        return URL(string: urlString)
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif = "gif"
    case jpg = "jpg"
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
