//
//  CharacterDetailController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CharacterDetailController: ASViewController<ASDisplayNode> {
    
    // Properties
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    private let dataProvider: MarvelDataProvider
    private let character: MarvelCharacter
    
    init(character: MarvelCharacter, dataProvider: MarvelDataProvider) {
        self.dataProvider = dataProvider
        self.character = character
        
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CharacterDetailController: ASTableDelegate {
    
}

extension CharacterDetailController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 6
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Comics"
        case 1:
            return "Series"
        case 2:
            return "Stories"
        case 3:
            return "Events"
        default:
            return nil
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            return HorizontalScrollController(character: self.character, dataProvider: self.dataProvider)
        })
        node.style.maxSize = CGSize(width: 200, height: 350)
        
        return node
    }
}
