//
//  SearchResultView.swift
//  Readrr
//
//  Created by Jorge Alvarez on 4/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class SearchResultView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        backgroundColor = .cyan
        
        // Image View
        
        // Title Label
        
        // Author Label
        
        // Rating View (stack view of image views?)
    }

}
