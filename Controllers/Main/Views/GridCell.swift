//
//  GridCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit
import QuickLookThumbnailing

final class GridCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GridCell"
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds.inset(by: UIEdgeInsets(top: 3, left: 4, bottom: 2, right: 1))
    }
}

extension GridCell {
    func configure(_ note: Note) {
        label.attributedText =  note.text?.captionAttributedText
    }
}

extension GridCell {
    
    private func setup() {
        label = {
            $0.lineBreakMode = .byCharWrapping
            $0.numberOfLines = 0
            $0.adjustsFontForContentSizeCategory = true
            return $0
        }(UILabel())
        
        contentView.addSubview(label)
        
        contentView.backgroundColor = UIColor.tertiarySystemBackground
        contentView.layer.cornerRadius = 4
    }
}
