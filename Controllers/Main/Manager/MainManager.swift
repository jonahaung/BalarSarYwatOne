//
//  OutlineManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import CoreData
import UIKit

protocol OutlineManagerDelegate: class {
    func manager(_ outlineManager: MainManager, didUpdateFolders folders: [Folder])
}

final class MainManager: NSObject {
    
    weak var delegate: OutlineManagerDelegate?
    var canRefresh = false
    let sectionItems: [MainSectionLayoutKind] = [MainSectionLayoutKind.SystemItems([.AllNotes, .DeletedNotes]), .PinnedNotes, .Folders]
    var allNotesCount = 0
    var folders = [Folder]()
    var pinnedNotes = [Note]()
}

extension MainManager: NSFetchedResultsControllerDelegate {
    
    func updateData() {
        pinnedNotes = Note.fetchPinned()
        folders = Folder.fetcheAll()
        allNotesCount = Note.allNotsCount()
        delegate?.manager(self, didUpdateFolders: folders)
    }
    func folder(at indexPath: IndexPath) -> Folder? {
        let folder = folders[indexPath.item]
        if canRefresh {
            PersistanceManager.shared.viewContext.refresh(folder, mergeChanges: true)
        }
        return folder
    }
}
