//
//  CharacterDetailNode.swift
//  MarvelForTest
//
//  Created by user on 15/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CharacterDetailNode: ASCellNode {
    private let character: MarvelCharacter
    private let nameNode = ASTextNode()
    private let detailsNode = ASTextNode()
    private let avatarImageNode = ASNetworkImageNode()
    
    init(character: MarvelCharacter) {
        self.character = character
        
        super.init()
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        avatarImageNode.url = character.thumbnail.url
        avatarImageNode.shouldRenderProgressImages = true
        avatarImageNode.contentMode = .scaleAspectFill
        addSubnode(avatarImageNode)
        
        nameNode.attributedText = NSAttributedString(string: character.name,
                                                     attributes: Constants.nameFont)
        nameNode.backgroundColor = .clear
        addSubnode(nameNode)
        
        detailsNode.attributedText = NSAttributedString(string: character.resultDescription,
                                                     attributes: Constants.descriptionFont)
        detailsNode.backgroundColor = .white
        addSubnode(detailsNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let photoDimension: CGFloat = constrainedSize.max.width
        avatarImageNode.style.preferredSize = CGSize(width: photoDimension, height: photoDimension)
        
        let nameInsets = UIEdgeInsets(top: CGFloat.infinity, left: Constants.bigInset, bottom: Constants.bigInset, right: Constants.bigInset)
        let textInsetSpec = ASInsetLayoutSpec(insets: nameInsets, child: nameNode)
        
        let imageWithName = ASOverlayLayoutSpec(child: avatarImageNode, overlay: textInsetSpec)
        if character.resultDescription.isEmpty {
            return imageWithName
        }
        
        let descInsets = UIEdgeInsets(top: Constants.smallInset, left: Constants.smallInset, bottom: Constants.smallInset, right: Constants.smallInset)
        let descriptionInsetSpec = ASInsetLayoutSpec(insets: descInsets, child: detailsNode)
        
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.verticalAlignment = .bottom
        verticalStackSpec.spacing = Constants.stackSpacing
        verticalStackSpec.children = [imageWithName, descriptionInsetSpec]
        return verticalStackSpec
    }
}
