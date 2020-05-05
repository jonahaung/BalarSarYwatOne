//
//  OutlineViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, Navigator {
    
    private let manager = MainManager()
    
    var dataSource: UICollectionViewDiffableDataSource<MainSectionLayoutKind, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    private let footerLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Folders"
        setup()
        manager.delegate = self
        configureDataSource()
        collectionView.setBackgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
        manager.updateData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.canRefresh = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userDefaults.updateObject(for: userDefaults.lastOpenedFolder, with: nil)
        userDefaults.updateObject(for: userDefaults.lastOpenedNote, with: nil)
        manager.canRefresh = false
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            collectionView?.setBackgroundImage()
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        
    }
    
}

extension MainViewController: OutlineManagerDelegate {
    
    func manager(_ outlineManager: MainManager, didUpdateFolders folders: [Folder]) {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<MainSectionLayoutKind, Int>()
       
        manager.sectionItems.forEach {
            
            snapshot.appendSections([$0])
            switch $0 {
            case .SystemItems(let items):
                let itemOffset = 0
                let x = Array(itemOffset..<items.count)
                
                snapshot.appendItems(x, toSection: $0)
            case .PinnedNotes:
                
                let x = Array(4..<(4 + manager.pinnedNotes.count))
                
                snapshot.appendItems(x, toSection: .PinnedNotes)
            case .Folders:
                let itemOffset = 4 + manager.pinnedNotes.count
                
                let ints = Array(itemOffset..<(itemOffset + outlineManager.folders.count))
                
                snapshot.appendItems(ints, toSection: .Folders)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        
        footerLabel.text = "\(folders.count) Folders"
    }
    
    
}

extension MainViewController {
    
    private func setup() {
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        
        navigationItem.rightBarButtonItems = [search]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "scribble", withConfiguration: UIImage.title3Configuration), style: .plain, target: self, action: #selector(didTapSettings(_:)))
        
        let createFolder = (UIBarButtonItem(title: "New Folder", style: .plain, target: self, action: #selector(didTapAddFolder(_:))))
        let scanner = UIBarButtonItem(image: UIImage(systemName: "camera.viewfinder", withConfiguration: UIImage.title3Configuration), style: .plain, target: self, action: #selector(didTapCamera(_:)))
        let addNote = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.title2Configuration), style: .plain, target: self, action: #selector(didTapAddNote(_:)))
        let labelItem = UIBarButtonItem(customView: footerLabel)
        
        toolbarItems = [createFolder, UIBarButtonItem.flexiable, labelItem, UIBarButtonItem.flexiable, scanner, addNote]
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.reuseIdentifier)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(ListHeaderCell.self, forCellWithReuseIdentifier: ListHeaderCell.reuseIdentifier)
        collectionView.contentInset.top = 20
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
}

// CollectionView
extension MainViewController: UICollectionViewDelegate {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let layoutKind = self.manager.sectionItems[sectionIndex]
            
            let columns = layoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupHeight = NSCollectionLayoutDimension.estimated(layoutKind.cellHeight)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainSectionLayoutKind, Int>(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            guard let self = self else { return nil}
            let section = self.manager.sectionItems[indexPath.section]
            switch section {
            case .SystemItems(let items):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListHeaderCell.reuseIdentifier, for: indexPath) as? ListHeaderCell else { fatalError() }
                let item = items[indexPath.item]
                cell.configure(item)
                return cell
            case .Folders:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else { fatalError() }
                if let folder = self.manager.folder(at: indexPath) {
                    cell.configure(folder: folder)
                }
                return cell
            case .PinnedNotes:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: indexPath) as? GridCell else { fatalError()}
                let note = self.manager.pinnedNotes[indexPath.item]
                
                cell.configure(note)
                return cell
                
            }
            
            
        }
        self.manager.updateData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sectionKind = manager.sectionItems[indexPath.section]
        switch sectionKind {
        case .Folders:
            if let folder = manager.folder(at: indexPath) {
                pushTo(NotesViewController(folder: folder))
            }
        case .SystemItems(let items):
            let item = items[indexPath.item]
            if item == .CreateNewFolder {
                didTapAddFolder(nil)
            }else {
                //                pushTo(NotesViewController(folder: nil, systemItemKind: item))
            }
            
        case .PinnedNotes:
            let note = manager.pinnedNotes[indexPath.item]
            pushTo(NotePadViewController(note: note))
        }
        
    }
    
    
}

extension MainViewController: ItemFactory {
    
    @objc private func didTapSettings(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SettingsViewController(), animated: true )
    }
    
    @objc private func didTapCamera(_ sender: UIBarButtonItem) {
        let vc = OcrViewController()
        vc.manager.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapAddNote(_ sender: UIBarButtonItem) {
        
        let note = itemFactory_createNote(text: "")
        pushTo(NotePadViewController(note: note))
    }
    @objc private func didTapAddFolder(_ sender: UIBarButtonItem?) {
        let alert = UIAlertController(title: "Create New Folder", message: nil, preferredStyle: .actionSheet)
        let textField = alert.addOneTextField()
        textField.autocapitalizationType = .words
        textField.placeholder = "New Folder Name"
        alert.addContinueAction {[weak textField] _ in
            if let text = textField?.text, !text.isEmpty {
                Folder.create(folderName: text)
                self.manager.updateData()
            }
        }
        alert.addCancelAction()
        alert.show()
    }
    
}

extension MainViewController: OcrManagerDelegate {
    func ocrService(_ service: OcrService, didDetect text: String) {
        guard let vc = service.cameraView.EXT_parentViewController else { return }
        vc.dismiss(animated: true, completion: {
            let note = self.itemFactory_createNote(text: text)
            self.pushTo(NotePadViewController(note: note))
        })
        
    }
    
    
}

extension MainViewController: ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        setLoading(true)
        scanner.dismiss(animated: true) {
            let image = results.originalScan.image
            OCRManager.shared.detectMyanmarTexts(for: image) { x in
                DispatchQueue.main.async {
                    setLoading(false)
                    if let texts = x?.cleanUpMyanmarTexts() {
                        let note = self.itemFactory_createNote(text: texts)
                        self.pushTo(NotePadViewController(note: note))
                    }
                    
                }
                
            }
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        
    }
}
