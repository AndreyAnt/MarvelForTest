//
//  MainCoordinator.swift
//  CoordinatorExample
//
//  Created by user on 30/01/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit

class MainCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let marvelService = MarvelService()
        let viewController = CharactersController(dataProvider: marvelService)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    fileprivate func showCharacterDetails(for character: MarvelCharacter) {
        let marvelService = MarvelService()
        let viewController = CharacterDetailController(character: character, dataProvider: marvelService)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: CharactersControllerDelegate {
    func characterSelected(_ character: MarvelCharacter) {
        showCharacterDetails(for: character)
    }
}
