//
//  NotesManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import CoreData

final class NotesManager: NSObject {
    
    let fetchRequest: NSFetchRequest<Note> = {
        $0.sortDescriptors = [NSSortDescriptor(key: "edited", ascending: false)]
        $0.returnsObjectsAsFaults = false
        $0.includesPendingChanges = true
        return $0
    }(NSFetchRequest<Note>(entityName: "Note"))
    
    lazy var frc: NSFetchedResultsController<Note> = NSFetchedResultsController<Note>(fetchRequest: fetchRequest, managedObjectContext: PersistanceManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    weak var delegate: NotesManagerDelegate? {
        didSet {
            delegate?.notesDidChange()
        }
    }
    
    var tableView: UITableView? {
        return delegate?.tableView
    }
    var folder: Folder? {
        return delegate?.folder
    }
    
    init(folder: Folder) {
        fetchRequest.predicate = NSPredicate(format: "folder == %@", folder)
        super.init()
        frc.delegate = self
        do {
            try self.frc.performFetch()
        }catch { print(error.localizedDescription) }
        
    }
    
    
}

extension NotesManager: Navigator {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = frc.object(at: indexPath)
        let vc = NotePadViewController(note: note)
        pushTo(vc)
    }
}
extension NotesManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frc.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reuseIdentifier, for: indexPath) as! NotesTableViewCell
        cell.configure(note, folder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Notes : \(frc.fetchedObjects?.count ?? 0)"
    }
}

extension NotesManager: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
        delegate?.notesDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            guard let i = newIndexPath else { return }
            tableView?.insertRows(at: [i], with: .automatic)
        case .delete:
            guard let i = indexPath else { return }
            tableView?.deleteRows(at: [i], with: .automatic)
        case .update:
            guard let i = indexPath, let new = newIndexPath else { return }
            tableView?.reloadRows(at: [i, new], with: .automatic)
            
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .automatic)
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
        default:
            break
        }
    }
}

