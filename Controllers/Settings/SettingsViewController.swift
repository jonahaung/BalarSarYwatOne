//
//  SettingsViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    class OutlineItem: Hashable {
        let title: String
        let indentLevel: Int
        let subitems: [OutlineItem]
        let outlineViewController: UIViewController.Type?
        
        var isExpanded = true
        
        init(title: String, indentLevel: Int = 0, viewController: UIViewController.Type? = nil, subitems: [OutlineItem] = []) {
            self.title = title
            self.indentLevel = indentLevel
            self.subitems = subitems
            self.outlineViewController = viewController
            self.isExpanded = title == "System"
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        var isGroup: Bool {
            return self.outlineViewController == nil
        }
        private let identifier = UUID()
    }
    
    private lazy var menuItems: [OutlineItem] = {
        return [
            OutlineItem(title: "System", indentLevel: 0, subitems: [
                OutlineItem(title: "All Folders", indentLevel: 1, viewController: UIViewController.self),
                OutlineItem(title: "Recents", indentLevel: 1, viewController: UIViewController.self),
                OutlineItem(title: "Recently Deleted", indentLevel: 1, viewController: UIViewController.self)
            ]),
            OutlineItem(title: "System", indentLevel: 0, subitems: [
                OutlineItem(title: "General", indentLevel: 1, subitems: [
                    OutlineItem(title: "List", indentLevel: 2, viewController: MainViewController.self),
                    
                    OutlineItem(title: "Per-Section Layout", indentLevel: 2, subitems: [
                        
                        OutlineItem(title: "Per-Section Layout", indentLevel: 3, subitems: [
                            
                            OutlineItem(title: "Per-Section Layout", indentLevel: 4, subitems: [
                                
                                OutlineItem(title: "Adaptive Sections", indentLevel: 5, viewController: MainViewController.self)
                            ])
                        ])
                    ])
                ]),
                
                OutlineItem(title: "Advanced Layouts", indentLevel: 1, subitems: [
                    OutlineItem(title: "Supplementary Views", indentLevel: 2, subitems: [
                        
                        OutlineItem(title: "Pinnned Section Headers", indentLevel: 3,
                                    viewController: MainViewController.self)
                    ]),
                    OutlineItem(title: "Section Background Decoration", indentLevel: 2,
                                viewController: MainViewController.self),
                    OutlineItem(title: "Orthogonal Sections", indentLevel: 2, subitems: [
                        OutlineItem(title: "Orthogonal Section Behaviors Orthogonal Section Behaviors", indentLevel: 3,
                                    viewController: MainViewController.self)
                    ])
                ]),
                OutlineItem(title: "Conference App", indentLevel: 1, subitems: [
                    OutlineItem(title: "Videos", indentLevel: 2,
                                viewController: MainViewController.self),
                    OutlineItem(title: "News", indentLevel: 2, viewController: MainViewController.self)
                ])
            ]),
            OutlineItem(title: "Custom", indentLevel: 0, subitems: [
                OutlineItem(title: "Mountains Search", indentLevel: 1, viewController: MainViewController.self),
                OutlineItem(title: "Settings: Wi-Fi", indentLevel: 1, viewController: MainViewController.self),
                OutlineItem(title: "Insertion Sort Visualization", indentLevel: 1,
                            viewController: MainViewController.self)
            ])
        ]
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Folders"
        collectionView.allowsMultipleSelection = true
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.frame = view.bounds
        collectionView.bounces = true
        collectionView.setBackgroundImage()
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.register(SettingsItemCell.self, forCellWithReuseIdentifier: SettingsItemCell.reuseIdentifer)
        configureDataSource()
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, menuItem: OutlineItem) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SettingsItemCell.reuseIdentifer,
                    for: indexPath) as? SettingsItemCell else { fatalError("Could not create new cell") }
                cell.label.text = menuItem.title
                cell.indentLevel = menuItem.indentLevel
                cell.isGroup = menuItem.isGroup
                cell.isExpanded = menuItem.isExpanded
                return cell
        }

        // load our initial data
        let snapshot = snapshotForCurrentState()
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            collectionView.setBackgroundImage()
        }
    }
    func generateLayout() -> UICollectionViewLayout {
        let itemHeightDimension = NSCollectionLayoutDimension.estimated(50)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, OutlineItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OutlineItem>()
        snapshot.appendSections([Section.main])
        func addItems(_ menuItem: OutlineItem) {
            snapshot.appendItems([menuItem])
            if menuItem.isExpanded {
                menuItem.subitems.forEach { addItems($0) }
            }
        }
        menuItems.forEach { addItems($0) }
        return snapshot
    }
    
    func updateUI() {
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
    }
    
    
}


extension SettingsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        print(menuItem)
        if menuItem.isGroup {
            menuItem.isExpanded.toggle()
            if let cell = collectionView.cellForItem(at: indexPath) as? SettingsItemCell {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.isExpanded = menuItem.isExpanded
                    self.updateUI()
                }) { done in
                    
                }
            }
        } else {
            if let viewController = menuItem.outlineViewController {
                let navController = UINavigationController(rootViewController: viewController.init())
                present(navController, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
