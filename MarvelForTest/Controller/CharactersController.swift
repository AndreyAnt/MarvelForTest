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
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.backgroundColor = .lightGray
        indicatorView.layer.cornerRadius = 3
        indicatorView.layer.masksToBounds = true
        return indicatorView
    }()
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
        self.tableNode.view.addSubview(activityIndicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Center the activity indicator view
        let bounds = tableNode.bounds
        activityIndicatorView.frame.origin = CGPoint(
            x: (bounds.width - activityIndicatorView.frame.width) / 2.0,
            y: (bounds.height - activityIndicatorView.frame.height) / 2.0
        )
    }
}

extension CharactersController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        defer { tableNode.deselectRow(at: indexPath, animated: true) }
        
        let character = characters[indexPath.section]
        delegate?.characterSelected(character)
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
        
        dataProvider
            .fetchCharacters(offset: characters.count)
            .ensure { [weak self] in
                guard let self = self else { return }
                self.activityIndicatorView.stopAnimating()
            }.done { [weak self] characters in
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
