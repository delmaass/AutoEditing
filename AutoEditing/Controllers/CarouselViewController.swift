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
    
    var images: [Image] = []
    private var imageView: UIImageView!
    private var currentIndex = 0
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInstance.setImages(images)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewInstance.clearImages()
    }
}
