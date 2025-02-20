//
//  CarouselView.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

class CarouselView: UIView {
    private var images: [Image] = []
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
        
        Networker.shared.download(URL(string: nextImage.url)!) { (data, error) in
            guard let data = data else {
                return
            }
            
            let image = UIImage(data: data)!
            
            DispatchQueue.main.async {
                UIView.transition(with: self.imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = image
                }) { _ in
                    self.startImageTransition()
                }
            }
        }
        
        currentIndex = (currentIndex + 1) % images.count
    }
    
    public func setImages(_ images: [Image]) {
        self.images = images
        fadeToNextImage()
    }
    
    public func clearImages() {
        self.images = []
    }
}
