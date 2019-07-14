//
//  Displayable.swift
//  MarvelForTest
//
//  Created by user on 14/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation

protocol Displayable {
    var id: Int { get }
    var title: String { get }
    var thumbnail: Thumbnail { get }
}
