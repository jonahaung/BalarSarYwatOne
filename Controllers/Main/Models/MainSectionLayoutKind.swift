//
//  MainSectionLayoutKind.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 17/4/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit

enum MainSectionLayoutKind: Hashable {

    case SystemItems([SystemItem])
    case PinnedNotes
    case Folders

    func columnCount(for width: CGFloat) -> Int {
        let wideMode = width > 600
        switch self {
        case .SystemItems:
            return 2
        case .Folders:
            return wideMode ? 2 : 1
        case .PinnedNotes:
            return 4
        }
    }

    var cellHeight: CGFloat {
        switch self {
        case .SystemItems:
            return 50
        case .Folders:
            return 44
        case .PinnedNotes:
            return 100
        }
    }

    var title: String? {
        switch self {
        case .SystemItems:
            return nil
        case .PinnedNotes:
            return "Pinned"
        case .Folders:
            return "Folders"
        }
    }

    enum SystemItem {
        case AllNotes, RecentsNotes, DeletedNotes, CreateNewFolder
        var imageName: String {
            switch self {
            case .AllNotes:
                return "doc.text.fill"
            case .RecentsNotes:
                return "archivebox.fill"
            case .DeletedNotes:
                return "trash.fill"
            case .CreateNewFolder:
                return "plus.circle.fill"
            }
        }
        var label: String {
            switch self {
            case .AllNotes:
                return "All Notes"
            case .RecentsNotes:
                return "Recents"
            case .DeletedNotes:
                return "Trash"
            case .CreateNewFolder:
                return "Ned Folder"
            }
        }
        var count: Int {
            switch self {
            case .AllNotes:
                return Note.allNotsCount()
            case .DeletedNotes:
                return Note.deletedCount()
            default:
                return 0
            }
        }
    }

}
