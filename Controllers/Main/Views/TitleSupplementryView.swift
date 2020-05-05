//
//  TitleSupplementryView.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit
class TitleSubView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSubView {
    func configure() {
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .semibold)
        addSubview(label)
        
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}

