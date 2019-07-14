//
//  HorizontalScrollController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HorizontalScrollController: ASViewController<ASDisplayNode> {
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    private var displayables = [Displayable]()
    private let character: MarvelCharacter
    private let dataProvider: MarvelDataProvider
    
    init(character: MarvelCharacter, dataProvider: MarvelDataProvider) {
        self.dataProvider = dataProvider
        self.character = character
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: collectionNode)
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        dataProvider
            .fetchComics(for: character)
            .done { [weak self] displayable in
                guard let self = self else { return }
                self.insert(displayable)
            }.catch { error in
                print(error)
        }
    }
    
    private func insert(_ newDisplayables: [Displayable]) {
        var indexPaths = [IndexPath]()
        let newNumberOfSections = displayables.count + newDisplayables.count
        for item in displayables.count ..< newNumberOfSections {
            indexPaths.append(IndexPath(item: item, section: 0))
        }
        
        displayables.append(contentsOf: newDisplayables)
        collectionNode.insertItems(at: indexPaths)
    }
}

extension HorizontalScrollController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height = collectionNode.view.bounds.height
        let width = collectionNode.view.bounds.width/2
        let minSize = CGSize(width: width, height: height)
        let maxSize = CGSize(width: width, height: height)
        return ASSizeRange(min: minSize, max: maxSize)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return false
    }
}

extension HorizontalScrollController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return displayables.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let displayable = self.displayables[indexPath.row]
        return { () -> ASCellNode in
            let node = DisplayableNode(displayable: displayable)
            return node
        }
    }
}