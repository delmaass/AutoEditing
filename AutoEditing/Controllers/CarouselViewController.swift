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
    
    var images: [Image] = [] {
        didSet {
            downloadImages()
        }
    }
    private var downloadedImages: [UIImage] = []
    
    override func loadView() {
        view = viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func downloadImages() {
        downloadedImages = []
        let group = DispatchGroup()
        
        for image in images {
            group.enter()
            Networker.shared.download(URL(string: image.url)!) { (data, error) in
                defer { group.leave() }
                guard let data = data,
                      let uiImage = UIImage(data: data) else {
                    return
                }
                self.downloadedImages.append(uiImage)
            }
        }
        
        group.notify(queue: .main) {
            self.viewInstance.setImages(self.downloadedImages)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewInstance.clearImages()
    }
}
