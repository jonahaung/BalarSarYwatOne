//
//  NotesManagerDelegate.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

protocol NotesManagerDelegate: class {
    var tableView: UITableView { get }
    var folder: Folder { get }
}
