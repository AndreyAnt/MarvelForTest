//
//  MainCoordinator.swift
//  CoordinatorExample
//
//  Created by user on 30/01/2019.
//  Copyright © 2019 Morizo Digital. All rights reserved.
//

import UIKit
import Swinject

/// Main application coordinator.
class MainCoordinator: CoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    var navigationController: UINavigationController
    let container: Container
    
    /// Initializing with main application navigation controller and swinject dependencies container
    ///
    /// - Parameters:
    ///   - navigationController
    ///   - container
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    /// Initial screen of this coordinator is CharactersController.
    func start() {
        let controller = container.resolve(CharactersController.self, argument: self as CharactersControllerDelegate)!
        navigationController.pushViewController(controller, animated: true)
    }
    
    /// Showing MarvelCharacter details screen if needed
    ///
    /// - Parameter character: character selected
    fileprivate func showCharacterDetails(for character: MarvelCharacter) {
        let controller = container.resolve(CharacterDetailController.self, argument: character)!
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MainCoordinator: CharactersControllerDelegate {
    /// If coordinator is set as CharactersControllerDelegate. It shows CharacterDetailController on character cell selection
    ///
    /// - Parameter character: selected character
    func characterSelected(_ character: MarvelCharacter) {
        showCharacterDetails(for: character)
    }
}
