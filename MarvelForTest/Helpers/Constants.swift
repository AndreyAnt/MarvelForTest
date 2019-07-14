//
//  Constants.swift
//  MarvelForTest
//
//  Created by user on 15/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit

/// General sizing constants for the application.
public enum Constants {
    static let smallInset: CGFloat = 8
    static let bigInset: CGFloat = 12
    static let comicsHeight: CGFloat = 350
    static let seriesHeight: CGFloat = 250
    static let avatarHeight: CGFloat = 100
    static let stackSpacing: CGFloat = 6
    static let titleHeight: CGFloat = 50
    
    static let nameFont: [NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 32, weight: .bold),
                                                          .strokeColor: UIColor.black,
                                                          .strokeWidth: -3,
                                                          .foregroundColor: UIColor.white]
    
    static let descriptionFont: [NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 20, weight: .regular),
    .foregroundColor: UIColor.black]
    static let titleFont: [NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16)]
}
