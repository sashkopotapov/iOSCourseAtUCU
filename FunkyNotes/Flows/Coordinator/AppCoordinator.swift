//
//  AppCoordinator.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator = NotesCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
