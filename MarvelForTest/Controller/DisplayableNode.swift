//
//  DisplayableNode.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class DisplayableNode: ASCellNode {
    //MARK: - Privates
    private let displayable: Displayable
    private let nameNode = ASTextNode()
    private let avatarImageNode = ASNetworkImageNode()
    
    init(displayable: Displayable) {
        self.displayable = displayable
        
        super.init()
        setupSubnodes()
    }
    
    // Configuring subnodes helper func
    private func setupSubnodes() {
        nameNode.attributedText = NSAttributedString(string: displayable.title, attributes: Constants.titleFont)
        nameNode.backgroundColor = .white
        nameNode.maximumNumberOfLines = 2
        addSubnode(nameNode)
        
        avatarImageNode.url = displayable.thumbnail.url
        avatarImageNode.shouldRenderProgressImages = true
        avatarImageNode.contentMode = .scaleAspectFit
        addSubnode(avatarImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        avatarImageNode.style.preferredSize = CGSize(width: constrainedSize.min.width,
                                                     height: constrainedSize.min.height - Constants.titleHeight)
        
        let insets = UIEdgeInsets(top: 0, left: Constants.smallInset, bottom: 0, right: Constants.smallInset)
        let nameInsetSpec = ASInsetLayoutSpec(insets: insets, child: nameNode)
        
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.verticalAlignment = .bottom
        verticalStackSpec.spacing = Constants.stackSpacing
        verticalStackSpec.children = [nameInsetSpec, avatarImageNode]
        return verticalStackSpec
    }
}
