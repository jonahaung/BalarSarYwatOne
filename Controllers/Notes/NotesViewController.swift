//
//  NotesViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    let tableView: UITableView = {
        $0.backgroundColor = nil
        $0.separatorColor = UIColor.secondarySystemFill
        $0.setBackgroundImage()
        $0.estimatedRowHeight = 70
        $0.rowHeight = UITableView.automaticDimension
        $0.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView()
        return $0
    }(UITableView(frame: UIScreen.main.bounds, style: .grouped))
    
    lazy var manager = NotesManager(folder: folder)
    let folder: Folder
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupDatasource()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            tableView.setBackgroundImage()
        }
    }
    
    
    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotesViewController {
    
    private func setupDatasource(){
        manager.delegate = self
        tableView.dataSource = manager
        tableView.delegate = manager
        
        
    }
    
    private func setup() {
        navigationItem.title = folder.name
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(didtapAdddNote(_:)))
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.setToolbarHidden(false, animated: true)
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), addNote]
        
    }
    
    
    @objc private func didtapAdddNote(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Note", message: nil, preferredStyle: .alert)
        let textField = alert.addOneTextField()
        textField.autocapitalizationType = .words
        textField.placeholder = "Title"
        textField.delegate = self
        alert.addContinueAction {[weak textField, weak self] (x) in
            if let text = textField?.text, !text.isEmpty {
                self?.manager.createNote(title: text)
            }
        }
        alert.addCancelAction()
        alert.show {[weak textField] in
            textField?.becomeFirstResponder()
        }
    }
}

extension NotesViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let hasText = textField.text != nil && textField.text?.isEmpty == false
        if let text = textField.text, !text.isEmpty {
            manager.createNote(title: text)
        }
        return hasText
    }
}

extension NotesViewController: NotesManagerDelegate {
    
}
