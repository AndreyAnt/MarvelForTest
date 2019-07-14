//
//  Displayable.swift
//  MarvelForTest
//
//  Created by user on 14/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation

/// Entities needed from item to be displayed in HorizontalScrollController
protocol Displayable {
    var id: Int { get }
    var title: String { get }
    var thumbnail: Thumbnail { get }
}

/// Marvel response is commonly data conforming to this protocol
protocol Fetchable: Codable {
    associatedtype DataOwner: DisplayableOwner
    
    var data: DataOwner { get }
    static var method: String { get }
}

protocol DisplayableOwner {
    associatedtype Item: Displayable
    
    var results: [Item] { get }
}


