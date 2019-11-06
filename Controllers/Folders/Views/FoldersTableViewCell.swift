//
//  FoldersTableViewCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "FoldersTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: FoldersTableViewCell.reuseIdentifier)
        setup()
    }
    
    private func setup() {
        backgroundColor = nil
        textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        imageView?.image = UIImage(systemName: "folder")
        accessoryType = .disclosureIndicator
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FoldersTableViewCell {
    
    func configure(_ folder: Folder) {
        textLabel?.text = folder.name
        detailTextLabel?.text = folder.notesCount.description
    }
}
