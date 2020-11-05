//
//  Coordinator.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
