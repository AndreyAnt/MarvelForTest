//
//  AppDelegate.swift
//  MarvelForTest
//
//  Created by user on 13/07/2019.
//  Copyright © 2019 AAA. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        let container = makeDefaultContainer()
        coordinator = MainCoordinator(navigationController: navController, container: container)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// Creates default application dependecies container.
    ///
    /// - Returns: Swinject container with bundled registrations
    private func makeDefaultContainer() -> Container {
        return Container(parent: nil, defaultObjectScope: ObjectScope.container, behaviors: []) { container in
            container.register(MarvelDataProvider.self, factory: { _ in
                return MarvelService()
            }).inObjectScope(.container)
            
            container.register(CharactersController.self, factory: { (resolver: Resolver, delegate: CharactersControllerDelegate)  in
                let dataProvider = resolver.resolve(MarvelDataProvider.self)!
                let controller = CharactersController(dataProvider: dataProvider)
                controller.delegate = delegate
                return controller
            }).inObjectScope(.transient)
            
            container.register(CharacterDetailController.self, factory: { (resolver: Resolver, character: MarvelCharacter) in
                let dataProvider = resolver.resolve(MarvelDataProvider.self)!
                return CharacterDetailController(character: character, dataProvider: dataProvider)
            }).inObjectScope(.transient)
        }
    }
}

