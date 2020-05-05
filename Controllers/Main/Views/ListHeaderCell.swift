//
//  ListHeaderCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit

final class ListHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "ListHeaderCell"
    
    private var label: UILabel!
    private var imageView: UIImageView!
    private var detailLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension ListHeaderCell {
    func configure() {
        imageView = {
            $0.preferredSymbolConfiguration = UIImage.SymbolConfiguration.init(textStyle: .title3)
            $0.setContentHuggingPriority(UILayoutPriority(700), for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIImageView())
        label = {
            $0.setContentHuggingPriority(UILayoutPriority(699), for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.adjustsFontForContentSizeCategory = true
            $0.font = UIFont.preferredFont(forTextStyle: .headline)
            $0.textColor = tintColor
            return $0
        }(UILabel())
        
        detailLabel = {
            $0.setContentHuggingPriority(UILayoutPriority(700), for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.adjustsFontForContentSizeCategory = true
            $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
            $0.textColor = .systemOrange
            $0.text = "10"
            return $0
        }(UILabel())
        
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.addSubview(detailLabel)
        
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset),
            
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.rightAnchor.constraint(equalTo: detailLabel.leftAnchor, constant: inset)
            
        ])
    }
    
    func configure(_ item:MainSectionLayoutKind.SystemItem) {
        imageView.image = UIImage(systemName: item.imageName)
        label.text = item.label
        detailLabel.text = item.count.description
    }
}
