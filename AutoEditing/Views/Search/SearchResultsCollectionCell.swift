//
//  SearchResultsCollectionCell.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

protocol SearchResultsCollectionCellDelegate: AnyObject {
    func onToggleSelected(_ id: String, selected: Bool)
}

class SearchResultsCollectionCell: UICollectionViewCell {
    private var id: String?
    let imageView = UIImageView()
    var checked = false {
        didSet {
            imageView.layer.borderColor = checked ? UIColor.blue.cgColor : nil
            imageView.layer.borderWidth = checked ? 2 : 0
        }
    }
    weak var delegate: SearchResultsCollectionCellDelegate?
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap() {
        guard let id = id else {
            return
        }
        
        checked = !checked
        delegate?.onToggleSelected(id, selected: checked)
    }
    
    public func configure(id: String, image: UIImage, selected: Bool) {
        self.id = id
        self.imageView.image = image
        self.checked = selected
    }
}
