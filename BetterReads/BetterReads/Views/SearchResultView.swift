//
//  SearchResultView.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class SearchResultView: UIView {

    var titleLabel: UILabel! // var title = uilabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        backgroundColor = .gray
        
        // Image View
        
        // Title Label
        let label = UILabel()
        addSubview(label)
        self.titleLabel = label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // constraints
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: CGFloat(8.0)).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(8.0)).isActive = true
        
        // Author Label
        
        // Rating View (stack view of image views?)
    }

}
