//
//  SearchResultsCollectionCell.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

class SearchResultsCollectionCell: UICollectionViewCell {
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
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
            make.width.greaterThanOrEqualTo(200)
        }
    }
}
