//
//  FoldersTableViewCell.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotesTableCell: UITableViewCell {
    
    static let reuseIdentifier = "FoldersTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: NotesTableCell.reuseIdentifier)
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

extension NotesTableCell {
    
    func configure(_ folder: Folder) {
        textLabel?.attributedText = folder.name?.titleAttributedText
        detailTextLabel?.text = folder.notesCount.description
    }
}
