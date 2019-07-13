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
    private let dataProvider: MarvelDataProvider
    private var characters = [MarvelCharacter]()
    
    init(dataProvider: MarvelDataProvider) {
        self.dataProvider = dataProvider
        
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
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        dataProvider
            .fetchCharacters(offset: characters.count)
            .done { characters in
                print("\(characters.count) characters fetched.")
                context.completeBatchFetching(true)
            }.catch { error in
                print(error)
                context.completeBatchFetching(true)
        }
    }
    
    private func insert(_ newCharacters: [MarvelCharacter]) {
        
        var indexSet = IndexSet()
        let newNumberOfSections = characters.count + newCharacters.count
        for section in characters.count ..< newNumberOfSections {
            indexSet.insert(section)
        }
        
        characters.append(contentsOf: newCharacters)
        tableNode.insertSections(indexSet, with: .automatic)
    }
}

extension CharactersController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let characterName = characters[indexPath.row].name
        let cellNodeBlock = { () -> ASCellNode in
            let node = ASCellNode(viewBlock: { () -> UIView in
                let label = UILabel()
                label.text = characterName
                return label
            })
            return node
        }
        
        return cellNodeBlock
    }
}
