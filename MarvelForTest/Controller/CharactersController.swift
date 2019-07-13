//
//  CharactersController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CharactersController: ASViewController<ASDisplayNode> {
    
    // Properties
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CharactersController: ASTableDelegate {
    
}

extension CharactersController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlock = { () -> ASCellNode in
            let node = ASCellNode()
            
            return node
        }
        
        return cellNodeBlock
    }
}
