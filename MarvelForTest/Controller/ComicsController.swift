//
//  ComicsController.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ComicsController: ASViewController<ASDisplayNode> {
    var collectionNode: ASCollectionNode {
        return node as! ASCollectionNode
    }
    private var comics = [Comics]()
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
            .done { [weak self] comics in
                guard let self = self else { return }
                self.insert(comics)
            }.catch { error in
                print(error)
        }
    }
    
    private func insert(_ newComics: [Comics]) {
        var indexPaths = [IndexPath]()
        let newNumberOfSections = comics.count + newComics.count
        for item in comics.count ..< newNumberOfSections {
            indexPaths.append(IndexPath(item: item, section: 0))
        }
        
        comics.append(contentsOf: newComics)
        collectionNode.insertItems(at: indexPaths)
    }
}

extension ComicsController: ASCollectionDelegate {
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

extension ComicsController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let comics = self.comics[indexPath.row]
        return { () -> ASCellNode in
            let node = ComicsNode(comics: comics)
            return node
        }
    }
}
