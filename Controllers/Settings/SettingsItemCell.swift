//
//  OutlineItemCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit

class SettingsItemCell: UICollectionViewCell {
 
    static let reuseIdentifer = "OutlineItemCell"
    let label = UILabel()
    let containerView = UIView()
    let imageView = UIImageView()
 
    var indentLevel: Int = 0 {
        didSet {
            indentContraint.constant = CGFloat(20 * indentLevel)
        }
    }
    var isExpanded = false {
        didSet {
            configureChevron()
        }
    }
    var isGroup = false {
        didSet {
            configureChevron()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            configureChevron()
        }
    }
    override var isSelected: Bool {
        didSet {
            configureChevron()
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChevron()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate var indentContraint: NSLayoutConstraint! = nil
    fileprivate let inset = CGFloat(10)
 }
 
 extension SettingsItemCell {
    func configure() {
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration.init(textStyle: .title3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
 
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        containerView.addSubview(label)
 
        indentContraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset)
        NSLayoutConstraint.activate([
            indentContraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
 
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
 
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
            ])
    }
 
    func configureChevron() {
//        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevron = "plus.circle.fill"
        let chevronSelected = "chevron.down.circle.fill"
        let doc = "doc.fill"
        let docFill = "doc"
        let highlighted = isHighlighted || isSelected
 
        if isGroup {
            let imageName = isExpanded ? chevronSelected : chevron
            let image = UIImage(systemName: imageName)
            imageView.image = image
//            let rtlMultiplier = rtl ? CGFloat(-1.0) : CGFloat(1.0)
//            let rotationTransform = isHighlighted ? CGAffineTransform(rotationAngle: rtlMultiplier * CGFloat.pi / 3) : CGAffineTransform.identity
//            imageView.transform = rotationTransform
            imageView.tintColor = nil
        } else {
            let imageName = highlighted ? docFill : doc
            let image = UIImage(systemName: imageName)
            imageView.image = image
//            imageView.transform = CGAffineTransform.identity
            imageView.tintColor = UIColor.systemYellow
        }
        label.font = isGroup ? UIFont.preferredFont(forTextStyle: .headline) : UIFont.preferredFont(forTextStyle: .body)
    }
 }
