//
//  ListCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit

final class ListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ListCell"
    private var label: UILabel!
    private var detailLabel: UILabel!
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("not implemented") }
}

extension ListCell {
    
    private func setup() {
        
        label = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.adjustsFontForContentSizeCategory = true
            $0.font = UIFont.preferredFont(forTextStyle: .headline)
            return $0
        }(UILabel())
        
        detailLabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.adjustsFontForContentSizeCategory = true
            $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
            $0.textColor = UIColor.tertiaryLabel
            return $0
        }(UILabel())
        
        imageView = {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIImageView())
        
        let seperatorView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .tertiarySystemFill
            return $0
        }(UIView())
    
        contentView.addSubview(seperatorView)
        contentView.addSubview(label)
        contentView.addSubview(detailLabel)
        contentView.addSubview(imageView)
        
        selectedBackgroundView = {
            $0.backgroundColor = .quaternarySystemFill
            return $0
        }(UIView())
        
        let inset = CGFloat(8)
        
        
        NSLayoutConstraint.activate([
            
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 1),
            
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: inset * 2),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            
            detailLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -inset),
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])

    }
    
    func configure(folder: Folder) {
        let noteCount = folder.notesCount
        let imageName = noteCount == 0 ? "folder" : "folder.fill"
        imageView.image = UIImage(systemName: imageName)
        detailLabel.text = noteCount == 0 ? nil : noteCount.description
        label.attributedText = (folder.name ?? "Genderal").titleAttributedText
    }
}
