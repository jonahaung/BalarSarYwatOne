//
//  Note+Ext.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 23/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    static func fetchPinned() -> [Note] {
        let fetchRequest: NSFetchRequest<Note> = {
             $0.sortDescriptors = [NSSortDescriptor(key: "edited", ascending: false)]
            $0.fetchLimit = 4
             return $0
         }(NSFetchRequest<Note>(entityName: "Note"))
        
        return (try? PersistanceManager.shared.viewContext.fetch(fetchRequest)) ?? []
        
    }
    static func createNote(folder: Folder?, text: String) {
        
    }
    static func fetch(title: String) -> Note? {
        let fetchRequest: NSFetchRequest<Note> = {
            $0.sortDescriptors = [NSSortDescriptor(key: "edited", ascending: false)]
            $0.predicate = NSPredicate(format: "title ==[c] %@", title)
            $0.fetchLimit = 1
            $0.returnsObjectsAsFaults = false
            $0.includesPendingChanges = false
             return $0
         }(NSFetchRequest<Note>(entityName: "Note"))
        
        return (try? PersistanceManager.shared.viewContext.fetch(fetchRequest))?.first
        
    }
    static func allNotsCount() -> Int {
        let request: NSFetchRequest<Note> = {
             return $0
         }(NSFetchRequest<Note>(entityName: "Note"))
    
        return (try? PersistanceManager.shared.viewContext.count(for: request)) ?? 0
        
    }
    
    static func deletedCount() -> Int {
        let request: NSFetchRequest<Note> = {
                 return $0
             }(NSFetchRequest<Note>(entityName: "Note"))
        request.predicate = NSPredicate(format: "type == %i", NoteType.deleted.rawValue)
        return (try? PersistanceManager.shared.viewContext.count(for: request)) ?? 0
    }
    
    static func create(_ text: String) -> Note {
        let context = PersistanceManager.shared.container.viewContext
        let note = Note(context: context)
        note.text = text
        note.folder = CurrentSession.currentFolder
        return note
    }
}
