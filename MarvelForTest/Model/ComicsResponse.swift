//
//  ComicsResponse.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation

// MARK: - ComicsResponse
struct ComicsResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: ComicsData
}

// MARK: - DataClass
struct ComicsData: Codable {
    let offset, limit, total, count: Int
    let results: [Comics]
}

// MARK: - Result
struct Comics: Codable {
    let id: Int
    let title: String
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, images
    }
}
