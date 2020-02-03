//
//  FoldersViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 1/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class FoldersViewController: UIViewController, ItemFactory, Navigator {
    
    let tableView: UITableView = {
        $0.backgroundColor = nil
        $0.setBackgroundImage()
        $0.separatorColor = UIColor.secondarySystemFill
        $0.register(FoldersTableViewCell.self, forCellReuseIdentifier: FoldersTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView()
        return $0
    }(UITableView(frame: UIScreen.main.bounds, style: .grouped))
    
    let footerLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.clearEmptyNotes()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: editButtonItem.action)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "signature", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)), style: .done, target: self, action: #selector(didTapSettings(_:)))
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        
        let cameraScanner = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(didTapCameraScanner(_:)))
        let photoScanner = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .done, target: self, action: #selector(didTapPhotoScanner(_:)))
        let newNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title2), scale: .large)), style: .done, target: self, action: #selector(didTapNewNote(_:)))
        let newFolder = UIBarButtonItem(title: "New Folder", style: .plain, target: self, action: #selector(didTapAddNewFolder(_:)))
        let label = UIBarButtonItem(customView: footerLabel)
        toolbarItems = [newFolder, UIBarButtonItem.flexiable, label, UIBarButtonItem.flexiable, photoScanner, cameraScanner, newNote]
    }
    
    @objc private func didTapSettings(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SettingsViewController(), animated: true )
    }
    
    @objc private func didTapCameraScanner(_ sender: UIBarButtonItem) {
        itemFactory_gotoEmptyNote(actionType: .OpenCameraScanner)
    }
    @objc private func didTapPhotoScanner(_ sender: UIBarButtonItem) {
        itemFactory_gotoEmptyNote(actionType: .OpenPhotoScanner)
    }
    @objc private func didTapNewNote(_ sender: UIBarButtonItem) {
        itemFactory_gotoEmptyNote(actionType: .None)
    }
    @objc private func didTapAddNewFolder(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Folder", message: nil, preferredStyle: .alert)
        let textField = alert.addOneTextField()
        textField.autocapitalizationType = .words
        textField.placeholder = "New Folder Name"
        textField.delegate = self
        alert.addContinueAction {[weak textField, weak self] (x) in
            if let text = textField?.text, !text.isEmpty {
                _ = self?.itemFactory_createFolder(name: text)
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
            _ = self.itemFactory_createFolder(name: text)
        }
        return hasText
    }
}

extension FoldersViewController: FoldersManagerDelegate {
    func foldersDidChange() {
        if let count = manager.frc.fetchedObjects?.count {
            footerLabel.text = "\(count) Folders"
        }
    }
}
