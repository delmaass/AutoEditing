//
//  Coordinator.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

class Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = ViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
