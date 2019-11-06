//
//  NotePadManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotePadManager: NSObject {
    
    weak var delegate: NotePadManagerDelegate?
    let context = PersistanceManager.shared.container.newBackgroundContext()
    let note: Note
    var textView: NotePadTextView? { return delegate?.textView }
    
    init(note: Note) {
        self.note = context.object(with: note.objectID) as! Note
        super.init()
    }
    
    deinit {
        context.saveIfHasChanges()
        NotificationCenter.default.removeObserver(self)
        print("Deinit : NotePadManager")
    }
    
    func save() {
        note.text = textView?.text
        note.attributedString = textView?.attributedText.toNSData()
        note.edited = Date()
    }
    func deleteNote() {
        context.refresh(note, mergeChanges: true)
        context.delete(note)
    }
}

extension NotePadManager: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.textViewDidEndEditing()
    }
    
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}

