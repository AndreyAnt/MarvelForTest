//
//  MainCoordinator.swift
//  CoordinatorExample
//
//  Created by user on 30/01/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit
import Swinject

class MainCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    let container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let controller = container.resolve(CharactersController.self, argument: self as CharactersControllerDelegate)!
        navigationController.pushViewController(controller, animated: true)
    }
    
    fileprivate func showCharacterDetails(for character: MarvelCharacter) {
        let controller = container.resolve(CharacterDetailController.self, argument: character)!
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MainCoordinator: CharactersControllerDelegate {
    func characterSelected(_ character: MarvelCharacter) {
        showCharacterDetails(for: character)
    }
}
