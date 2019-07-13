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
    func fetchCharacters() -> Promise<[MarvelCharacter]>
}

class MarvelService: MarvelDataProvider {
    private let publicKey = "1e5fefd2498c35af0c1de75f03cb9eb0"
    private let baseEndpoint = "https://gateway.marvel.com/"
    
    public func fetchCharacters() -> Promise<[MarvelCharacter]> {
        let method = "/v1/public/characters"
        let request = prepareRequest(for: method)
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .map { try JSONDecoder().decode(CharactersResponse.self, from: $0.data) }
            .map { $0.data.characters }
    }
    
    private func prepareRequest(for method: String) -> URLRequest {
        guard let url = URL(string: baseEndpoint + method) else { preconditionFailure("Check your request method properly") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
