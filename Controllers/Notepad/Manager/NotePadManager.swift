//
//  NotePadManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import CoreData
import NaturalLanguage

protocol NotePadManagerDelegate: class {
    var textView: NotePadTextView { get }
    func textViewDidEndEditing()
    func textViewDidBeginEditing()
    func notePadManager(_ manager: NotePadManager, didCreateNew note: Note)
}

final class NotePadManager: NSObject {
    
    weak var delegate: NotePadManagerDelegate? {
        didSet {
            
            textView?.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:))))
        }
    }
    var isMyanmar = true
//    private let context = PersistanceManager.shared.container.newBackgroundContext()
    private var note: Note?
    private var textView: NotePadTextView? { return delegate?.textView }
    private let oprationQueue: OperationQueue = {
        $0.qualityOfService = .background
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    init(note: Note?) {
        self.note = note
        super.init()
    }
    
    deinit {
        
        print("Deinit : NotePadManager")
    }
    
    func save() {
        if self.note == nil {
            if let text = textView?.text {
                note = Note.create(text)
                delegate?.notePadManager(self, didCreateNew: note!)
            }
        }
        
        note?.text = textView?.text
        note?.edited = Date()
        note?.title = note?.text?.firstWord.trimmed
        PersistanceManager.shared.saveContext()
    }
    func deleteNote() {
        guard let note = note else { return }
        let context = PersistanceManager.shared.viewContext
        context.refresh(note, mergeChanges: true)
        context.delete(note)
    }

}

extension NotePadManager: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        save()
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let subString = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if !subString.isEmpty {
            findCompletions(text: subString)
        }
        return true
    }
}

extension NotePadManager {
    
    private func findCompletions(text: String) {
        
        oprationQueue.cancelAllOperations()
        
        oprationQueue.addOperation {[weak self] in
            guard let `self` = self else { return }
            
            let lastWord = text.lastWord.trimmed
            
            var suggestingText: String?
            
            suggestingText = self.completion(for: lastWord)
            OperationQueue.main.addOperation {
                self.textView?.suggestedText = suggestingText
            }
        }
    }
    
    private func completion(for word: String) -> String? {
        let encoded = word.urlEncoded
        let encodedLength = encoded.utf16.count
        
        let request = NSFetchRequest<Saidict>(entityName: "Saidict")
        
        request.predicate = NSPredicate(format: "mya BEGINSWITH %@ && mya != %@", argumentArray: [encoded, encoded])
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = ["mya"]
        request.fetchLimit = 1
        do{
            if let found = try PersistanceManager.shared.viewContext.fetch(request).first, let encodedFoundText = found.mya {
                
                return String(encodedFoundText.dropFirst(encodedLength)).urlDecoded
            }
        } catch {
            print(error.localizedDescription)
            
        }
        return nil
    }
}

extension NotePadManager: UIGestureRecognizerDelegate {
    @objc private func swipeRight(_ gesture: UISwipeGestureRecognizer) {
        gesture.delaysTouchesBegan = true
        if let textView = self.textView, let text = textView.text, !text.isEmpty {
            
            if let suggestion = textView.suggestedText {
                textView.suggestedText = nil
                textView.insertText(suggestion+" ")
                
                gesture.delaysTouchesEnded = true
                
            } else {
                if text.hasSuffix(" ") {
                    textView.deleteBackward()
                    gesture.delaysTouchesEnded = true
                    return
                }
                (1...text.lastWord.utf16.count).forEach { _ in
                    textView.deleteBackward()
                }
                gesture.delaysTouchesEnded = true
            }
            textView.ensureCaretToTheEnd()
        }
    }
}
