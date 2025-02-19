//
//  Coordinator.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    var coordinator: Coordinator? { get set }
}

enum Screen {
    case search, carousel
}

class Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SearchViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToCarousel(images: [Image]) {
        let viewController = CarouselViewController()
        viewController.images = images
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
