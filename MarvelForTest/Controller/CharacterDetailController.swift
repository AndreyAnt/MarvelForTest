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
        
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CharacterDetailController: ASTableDataSource {
    /// Displaying three sections.
    /// Topmost for big photo header with description.
    /// Second is for comics collection with this character
    /// Third one displays series in which this character took part.
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Comics"
        case 2:
            return "Series"
        default:
            return nil
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        switch indexPath.section {
        case 0:
            return CharacterDetailNode(character: character)
        case 1:
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
                return HorizontalScrollController<ComicsResponse>(character: self.character, dataProvider: self.dataProvider)
            })
            node.style.maxSize = CGSize(width: Constants.comicsHeight, height: Constants.comicsHeight)
            
            return node
        case 2:
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
                return HorizontalScrollController<SeriesResponse>(character: self.character, dataProvider: self.dataProvider)
            })
            node.style.maxSize = CGSize(width: Constants.seriesHeight, height: Constants.seriesHeight)
            
            return node
        default:
            preconditionFailure("Check number of sections properly")
        }
    }
}
