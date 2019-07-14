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
    private let displayable: Displayable
    private let nameNode = ASTextNode()
    private let avatarImageNode = ASNetworkImageNode()
    
    init(displayable: Displayable) {
        self.displayable = displayable
        
        super.init()
        setupSubnodes()
    }
    
    private func setupSubnodes() {
        nameNode.attributedText = NSAttributedString(string: displayable.title, attributes: [.font : UIFont.systemFont(ofSize: 16)])
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
                                                     height: constrainedSize.min.height - 50)
        
        let verticalStackSpec = ASStackLayoutSpec()
        verticalStackSpec.direction = .vertical
        verticalStackSpec.verticalAlignment = .bottom
        verticalStackSpec.spacing = 6
        verticalStackSpec.children = [nameNode, avatarImageNode]
        return verticalStackSpec
    }
}
