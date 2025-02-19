//
//  CarouselViewController.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit

class CarouselViewController: UIViewController, CoordinatorDelegate {
    private let viewInstance = CarouselView()
    weak var coordinator: Coordinator?
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
