//
//  Folders+Ext.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 23/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import CoreData

extension Folder {
    static func fetcheAll() -> [Folder] {
        let fetchRequest: NSFetchRequest<Folder> = {
            $0.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
            $0.includesPendingChanges = true
            return $0
        }(NSFetchRequest<Folder>(entityName: "Folder"))
        return (try? PersistanceManager.shared.viewContext.fetch(fetchRequest)) ?? []
       
    }
    
    static func fetch(name: String) -> Folder? {
        let fetchRequest: NSFetchRequest<Folder> = {
            $0.predicate = NSPredicate(format: "name ==[c] %@", name)
            $0.fetchLimit = 1
            return $0
        }(NSFetchRequest<Folder>(entityName: "Folder"))
        return (try? PersistanceManager.shared.viewContext.fetch(fetchRequest))?.first
       
    }
    static func create(folderName: String) {
        let context = PersistanceManager.shared.container.newBackgroundContext()
        let x = Folder(context: context)
        x.name = folderName
        x.created = Date()
        context.saveIfHasChanges()
    }
}
