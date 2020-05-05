//
//  NoteType.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import Foundation

enum NoteType: Int16 {
    case normal, deleted
}


extension Note  {
    var noteType: NoteType {
        return NoteType(rawValue: type) ?? .normal
    }
}
