//
//  SeriesResponse.swift
//  MarvelForTest
//
//  Created by user on 14/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation

// MARK: - SeriesResponse
struct SeriesResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: SeriesData
}

// MARK: - DataClass
struct SeriesData: Codable {
    let offset, limit, total, count: Int
    let results: [Series]
}

// MARK: - Result
struct Series: Codable, Displayable {
    let id: Int
    let title: String
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, images
    }
}
