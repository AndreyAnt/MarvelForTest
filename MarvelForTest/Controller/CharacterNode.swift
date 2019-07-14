//
//  CharacterNode.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CharacterNode: ASCellNode {
    //MARK: - Private properties
    private let character: MarvelCharacter
    private let nameNode = ASTextNode()
    private let avatarImageNode = ASNetworkImageNode()
    
    init(character: MarvelCharacter) {
        self.character = character
        
        super.init()
        setupSubnodes()
    }
    
    // Configuring subnodes helper func
    private func setupSubnodes() {
        nameNode.attributedText = NSAttributedString(string: character.name, attributes: [.font : UIFont.systemFont(ofSize: 20)])
        nameNode.backgroundColor = .clear
        addSubnode(nameNode)
        
        avatarImageNode.url = character.thumbnail.url
        avatarImageNode.cornerRadius = Constants.avatarHeight/2
        avatarImageNode.clipsToBounds = true
        avatarImageNode.shouldRenderProgressImages = true
        avatarImageNode.contentMode = .scaleAspectFill
        addSubnode(avatarImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        avatarImageNode.style.preferredSize = CGSize(width: Constants.avatarHeight, height: Constants.avatarHeight)
        let insets = UIEdgeInsets(top: 0, left: Constants.bigInset, bottom: 0, right: Constants.bigInset)
        let avatarWithInset = ASInsetLayoutSpec(insets: insets, child: avatarImageNode)
        
        let textCenterSpec = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [], child: nameNode)
        
        let horizontalStackSpec = ASStackLayoutSpec()
        horizontalStackSpec.direction = .horizontal
        horizontalStackSpec.children = [avatarWithInset, textCenterSpec]
        return horizontalStackSpec
    }
}
