//
//  MarvelService.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import PromiseKit

protocol MarvelDataProvider {
    func fetchCharacters(offset: Int) -> Promise<[MarvelCharacter]>
    func fetch<T: Fetchable>(_ type: T.Type, for character: MarvelCharacter) -> Promise<[T.DataOwner.Item]>
}

/// Marvel API service provider
class MarvelService: MarvelDataProvider {
    private typealias TimeStamp = String
    private let publicKey = "1e5fefd2498c35af0c1de75f03cb9eb0"
    private let privateKey = "681078e90a0780a64d2fd45764a17e6730582fa6"
    private let scheme = "https"
    private let host = "gateway.marvel.com"
    private let baseEndpoint = "https://gateway.marvel.com/"
    
    /// Base function for fetching all possible marvel characters.
    /// Batch size is set to 20 characters.
    ///
    /// - Parameter offset: offset used for partial data requesting.
    /// - Returns: PromiseKit.Promise containing MarvelCharacters
    public func fetchCharacters(offset: Int) -> Promise<[MarvelCharacter]> {
        let method = "/v1/public/characters"
        let request = prepareRequest(for: method, offset: offset)
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .map { try JSONDecoder().decode(CharactersResponse.self, from: $0.data) }
            .map { $0.data.characters }
    }
    
    /// Generic func for fetching any Fetchable data from Marvel API.
    ///
    /// - Parameters:
    ///   - type: generic data type
    ///   - character: character related to which the fetch is performed
    /// - Returns: PromiseKit.Promise containing Items bounds to Fetchable type
    public func fetch<T: Fetchable>(_ type: T.Type, for character: MarvelCharacter) -> Promise<[T.DataOwner.Item]> {
        let method = "/v1/public/characters/\(character.id)" + T.method
        let request = prepareRequest(for: method, offset: 0)
        
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .map { try JSONDecoder().decode(T.self, from: $0.data) }
            .map { $0.data.results }
    }
    
    /// Helper func prepairing network request which is eligible to Marvel API.
    ///
    /// - Parameters:
    ///   - method: method used for parameter fetching
    ///   - offset: offset used for partial data requesting.
    /// - Returns: actual URL request.
    private func prepareRequest(for method: String, offset: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method
        let timestamp = generateTimestamp()
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: calculateHash(for: timestamp)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("Check your request method properly") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    /// Helper function requied for creating timestamp parameter requied by Marvel API.
    ///
    /// - Returns: Sting representation of current time
    private func generateTimestamp() -> TimeStamp {
        return String(Date().timeIntervalSince1970)
    }
    
    /// Helper function requied for creating md5 hash parameter requied by Marvel API.
    ///
    /// - Parameter timestamp: timestanp based on which hash is computed.
    /// - Returns: hash string representation
    private func calculateHash(for timestamp: TimeStamp) -> String {
        let md5Data = MD5(string: timestamp + privateKey + publicKey)
        return md5Data.map { String(format: "%02hhx", $0) }.joined()
    }
}
