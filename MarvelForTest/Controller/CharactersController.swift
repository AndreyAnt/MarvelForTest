//
//  CharactersController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol CharactersControllerDelegate: class {
    func characterSelected(_ character: MarvelCharacter)
}

class CharactersController: ASViewController<ASDisplayNode> {
    
    // Properties
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    public weak var delegate: CharactersControllerDelegate?
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
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        defer { tableNode.deselectRow(at: indexPath, animated: true) }
        
        let character = characters[indexPath.section]
        delegate?.characterSelected(character)
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        dataProvider
            .fetchCharacters(offset: characters.count)
            .done { [weak self] characters in
                guard let self = self else { return }
                self.insert(characters)
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
        return characters.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let character = characters[indexPath.section]
        let cellNodeBlock = { () -> ASCellNode in
            let node = CharacterNode(character: character)
            return node
        }
        
        return cellNodeBlock
    }
}
