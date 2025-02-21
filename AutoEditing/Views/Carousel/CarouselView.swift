//
//  CarouselView.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

class CarouselView: UIView {
    private var images: [UIImage] = []
    private let imageView = UIImageView()
    private var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .lightGray
        
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func startImageTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.fadeToNextImage()
        }
    }
    
    private func fadeToNextImage() {
        guard !images.isEmpty else { return }
        
        let nextImage = images[currentIndex]

        UIView.transition(with: self.imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.imageView.image = nextImage
        }) { _ in
            self.startImageTransition()
        }
        
        currentIndex = (currentIndex + 1) % images.count
    }
    
    public func setImages(_ images: [UIImage]) {
        self.images = images
        fadeToNextImage()
    }
    
    public func clearImages() {
        self.images = []
    }
}
