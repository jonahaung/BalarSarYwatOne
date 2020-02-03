//
//  FoldersManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import CoreData

final class FoldersManager: NSObject {
    
    let fetchRequest: NSFetchRequest<Folder> = {
        $0.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        return $0
    }(NSFetchRequest<Folder>(entityName: "Folder"))
    
    lazy var frc: NSFetchedResultsController<Folder> = NSFetchedResultsController<Folder>(fetchRequest: fetchRequest, managedObjectContext: PersistanceManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    weak var delegate: FoldersManagerDelegate? {
        didSet {
            delegate?.foldersDidChange()
        }
    }
    
    var tableView: UITableView? {
        return delegate?.tableView
    }
    override init() {
        super.init()
        
        do {
            try frc.performFetch()
        }catch { print(error.localizedDescription) }
        frc.delegate = self
    }
    func clearEmptyNotes() {
        let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "text == %@", "")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    

        do {
            try PersistanceManager.shared.viewContext.execute(batchDeleteRequest)
            PersistanceManager.shared.saveContext()
        }catch {
            print(error)
        }
        
    }
}

extension FoldersManager: Navigator {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let folder = frc.object(at: indexPath)
        let vc = NotesViewController(folder: folder)
        pushTo(vc)
    }
}
extension FoldersManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frc.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let folder = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: FoldersTableViewCell.reuseIdentifier, for: indexPath) as! FoldersTableViewCell
        cell.configure(folder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Folders : \(frc.fetchedObjects?.count ?? 0)"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let flagAction = self.contextualToggleFlagAction(forRowAtIndexPath: indexPath)
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [flagAction])
        return swipeConfig
    }
    
    func contextualToggleFlagAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let folder = frc.object(at: indexPath)
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            PersistanceManager.shared.viewContext.delete(folder)
            PersistanceManager.shared.saveContext()
            completionHandler(true)
        }
        // 7
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}

extension FoldersManager: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
        delegate?.foldersDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            guard let i = newIndexPath else { return }
            tableView?.insertRows(at: [i], with: .fade)
        case .delete:
            guard let i = indexPath else { return }
            tableView?.deleteRows(at: [i], with: .fade)
        case .update:
            guard let i = indexPath else { return }
            tableView?.reloadRows(at: [i], with: .automatic)
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex) as IndexSet
        switch type {
        case .insert:
            tableView?.insertSections(indexSet, with: .fade)
        case .delete:
            tableView?.deleteSections(indexSet, with: .fade)
        case .update:
            tableView?.reloadSections(indexSet, with: .fade)
        default:
            break
        }
    }
    
    
    
}
