//
//  FoldersViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 1/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class FoldersViewController: UIViewController {
    
    let tableView: UITableView = {
        
        $0.backgroundColor = nil
        $0.setBackgroundImage()
        $0.separatorColor = UIColor.secondarySystemFill
        $0.register(FoldersTableViewCell.self, forCellReuseIdentifier: FoldersTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView()
       return $0
    }(UITableView(frame: UIScreen.main.bounds, style: .grouped))
    
    lazy var manager = FoldersManager()
    
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
}

extension FoldersViewController {
    
    private func setupDatasource(){
        tableView.delegate = manager
        tableView.dataSource = manager
        manager.delegate = self
    }
    
    override var isEditing: Bool {
        didSet {
            tableView.isEditing = isEditing
        }
    }
    
    private func setup() {
        navigationItem.title = "Folders"
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "signature"), style: .plain, target: self, action: #selector(didTapSettings(_:)))
        navigationController?.setToolbarHidden(false, animated: true)
        let addNote = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didtapAdddNot(_:)))
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), addNote]
    }
    
    @objc private func didTapSettings(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SettingsViewController(), animated: true )
    }
    
    @objc private func didtapAdddNot(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Folder", message: nil, preferredStyle: .alert)
        let textField = alert.addOneTextField()
        textField.autocapitalizationType = .words
        textField.placeholder = "New Folder Name"
        textField.delegate = self
        alert.addContinueAction {[weak textField, weak self] (x) in
            if let text = textField?.text, !text.isEmpty {
                self?.manager.createFolder(name: text)
            }
        }
        alert.addCancelAction()
        alert.show {
            textField.becomeFirstResponder()
        }
    }
}

extension FoldersViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let hasText = textField.text != nil && textField.text?.isEmpty == false
        if let text = textField.text, !text.isEmpty {
            manager.createFolder(name: text)
        }
        return hasText
    }
}

extension FoldersViewController: FoldersManagerDelegate {
    
}
