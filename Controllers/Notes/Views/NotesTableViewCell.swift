//
//  NotesTableViewCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NotesTableViewCell"
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        return $0
    }(UILabel())
    
    private let subtitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = UIColor.secondaryLabel
        return $0
    }(UILabel())
    
    private let folderImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "folder")
        $0.tintColor = UIColor.tertiaryLabel
        return $0
    }(UIImageView())
    
    private let folderNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = UIColor.tertiaryLabel
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FoldersTableViewCell.reuseIdentifier)
        setup()
    }
    
    private func setup() {
        backgroundColor = nil
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(folderImageView)
        contentView.addSubview(folderNameLabel)
        
        let padding = UIEdgeInsets(top: 10, left: 25, bottom: -10, right: -25)
        
        contentView.addConstraints([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.left),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: padding.right),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top),
            
            subtitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.left),
            subtitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: padding.right),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            
            folderImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 3),
            folderImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.left),
            folderImageView.widthAnchor.constraint(equalToConstant: 18),
            folderImageView.heightAnchor.constraint(equalToConstant: 18),
            folderImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: padding.bottom),
            
            folderNameLabel.leftAnchor.constraint(equalTo: folderImageView.rightAnchor, constant: 3),
            folderNameLabel.centerYAnchor.constraint(equalTo: folderImageView.centerYAnchor)
        ])
        accessoryType = .disclosureIndicator
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotesTableViewCell {
    
    func configure(_ note: Note) {
        titleLabel.text = note.title
        if let time = note.edited?.relativeString {
            let text = note.text ?? "No Additional Text"
            let attrStr = NSMutableAttributedString(string: "\(time) ", attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline), .foregroundColor: UIColor.secondaryLabel])
            let textAttrStr = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .callout), .foregroundColor: UIColor.tertiaryLabel])
            attrStr.append(textAttrStr)
            subtitleLabel.attributedText = attrStr
        }
        folderNameLabel.text = note.folder?.name
    }
}

