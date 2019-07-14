//
//  HorizontalScrollController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HorizontalScrollController<T: Fetchable>: ASViewController<ASDisplayNode>, ASCollectionDelegate, ASCollectionDataSource {
    //MARK: - Properties
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    private typealias MarvelData = Displayable
    private var displayables = [MarvelData]()
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
    
    /// Loading this controller runs network request for fetching any data conforming to Displayable protocol
    override func viewDidLoad() {
        dataProvider
            .fetch(T.self, for: character)
            .done { [weak self] displayable in
                guard let self = self else { return }
                self.insert(displayable)
            }.catch { error in
                print(error)
        }
    }
    
    /// Helper func in order to insert new character into the table node.
    private func insert(_ newDisplayables: [MarvelData]) {
        var indexPaths = [IndexPath]()
        let newNumberOfSections = displayables.count + newDisplayables.count
        for item in displayables.count ..< newNumberOfSections {
            indexPaths.append(IndexPath(item: item, section: 0))
        }
        
        displayables.append(contentsOf: newDisplayables)
        collectionNode.insertItems(at: indexPaths)
    }

    //MARK: - ASCollectionDelegate methods
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

    //MARK: - ASCollectionDataSource methods
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
