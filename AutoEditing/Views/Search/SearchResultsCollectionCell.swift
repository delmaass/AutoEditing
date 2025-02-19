//
//  SearchResultsCollectionCell.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

class SearchResultsCollectionCell: UICollectionViewCell {
    let imageView = UIImageView()
    
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
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
            make.width.greaterThanOrEqualTo(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    public func set(image: UIImage) {
        imageView.image = image
        self.layoutIfNeeded()
    }
}
