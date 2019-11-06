//
//  NotePadManagerDelegate.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import Foundation

protocol NotePadManagerDelegate: class {
    var textView: NotePadTextView { get }
    
    func textViewDidEndEditing()
    func textViewDidBeginEditing()
}
