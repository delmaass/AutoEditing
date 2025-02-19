//
//  CarouselView.swift
//  AutoEditing
//
//  Created by Louis Delmas on 19/02/2025.
//

import UIKit
import SnapKit

class CarouselView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .magenta
    }
}
