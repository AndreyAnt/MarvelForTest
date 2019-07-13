//
//  MarvelService.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import PromiseKit

class MarvelService {
    private let publicKey = "1e5fefd2498c35af0c1de75f03cb9eb0"
    private let baseEndpoint = "https://gateway.marvel.com/"
    
    public func fetchCharacters() -> Promise<[MarvelCharacter]> {
        let path = "/v1/public/characters"
        
        return Promise(error: PMKError.emptySequence)
    }
}
