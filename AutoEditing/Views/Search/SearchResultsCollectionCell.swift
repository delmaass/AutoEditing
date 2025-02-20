//
//  SearchResultsCollectionCell.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

protocol SearchResultsCollectionCellDelegate: AnyObject {
    func onToggleSelected(_ image: Image, selected: Bool)
}

class SearchResultsCollectionCell: UICollectionViewCell {
    var image: Image?
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
        guard let image = image else {
            return
        }
        
        checked = !checked
        delegate?.onToggleSelected(image, selected: checked)
    }
    
    public func set(image: Image, selected: Bool) {
        self.imageView.image = nil
        self.layoutIfNeeded()
        
        self.image = image
        self.checked = selected
        
        Networker.shared.download(URL(string: image.url)!) { (data, error) in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
                self.layoutIfNeeded()
            }
        }
    }
}
