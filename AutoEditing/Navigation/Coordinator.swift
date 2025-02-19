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
        navigate(to: .search)
    }
    
    func navigate(to screen: Screen) {
        let viewController: UIViewController
        
        switch screen {
            case .search:
                viewController = SearchViewController()
            case .carousel:
                viewController = CarouselViewController()
        }
        
        (viewController as? CoordinatorDelegate)?.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
