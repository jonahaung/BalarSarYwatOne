//
//  Ext+NSAttributedString.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    func toNSData() -> Data? {
        let options : [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.rtfd, .characterEncoding: String.Encoding.utf8]

        let range = NSRange(location: 0, length: length)
    
        
        return try? data(from: range, documentAttributes: options)
    }
}

extension Data {
    
    func toAttributedString() -> NSAttributedString? {
        let data = self
        let options : [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.rtfd, .characterEncoding: String.Encoding.utf8]

        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}

extension NSMutableAttributedString {
    
    convenience init?(base64EndodedImageString encodedImageString: String) {
        let html = """
        <!DOCTYPE html>
        <html>
        <body>
        <img src="data:image/png;base64,\(encodedImageString)">
        </body>
        </html>
        """
        let data = Data(html.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        try? self.init(data: data, options: options, documentAttributes: nil)
    }

    func bold() {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let f = value as? UIFont {
                var traits = f.fontDescriptor.symbolicTraits
                traits.insert(UIFontDescriptor.SymbolicTraits.traitBold)
                
                if let descriptor = f.fontDescriptor.withSymbolicTraits(traits) {
                    let font = UIFont(descriptor: descriptor, size: 0)
                    removeAttribute(.font, range: range)
                    addAttribute(.font, value: font, range: range)
                }
            }
        }
        endEditing()
    }
    
    func unBold() {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let f = value as? UIFont {
                var traits = f.fontDescriptor.symbolicTraits
                traits.remove(UIFontDescriptor.SymbolicTraits.traitBold)
                
                if let descriptor = f.fontDescriptor.withSymbolicTraits(traits) {
                    let font = UIFont(descriptor: descriptor, size: 0)
                    removeAttribute(.font, range: range)
                    addAttribute(.font, value: font, range: range)
                }
            }
        }
        endEditing()
    }
    
    func unItalic() {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let f = value as? UIFont {
                var traits = f.fontDescriptor.symbolicTraits
                traits.remove(UIFontDescriptor.SymbolicTraits.traitItalic)
                
                if let descriptor = f.fontDescriptor.withSymbolicTraits(traits) {
                    let font = UIFont(descriptor: descriptor, size: 0)
                    removeAttribute(.font, range: range)
                    addAttribute(.font, value: font, range: range)
                }
            }
        }
        endEditing()
    }
    
    func italic() {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let f = value as? UIFont {
                var traits = f.fontDescriptor.symbolicTraits
                traits.insert(UIFontDescriptor.SymbolicTraits.traitItalic)
                
                if let descriptor = f.fontDescriptor.withSymbolicTraits(traits) {
                    let font = UIFont(descriptor: descriptor, size: 0)
                    removeAttribute(.font, range: range)
                    addAttribute(.font, value: font, range: range)
                }
            }
        }
        endEditing()
    }
    
    func toggleBoldFont() {
        guard let firstCharFont = attribute(.font, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.length)) as? UIFont else { return }
        
        if (firstCharFont.isBold) {
            unBold()
        } else {
            bold()
        }
    }
    
    func toggleItalicFont() {
        guard let firstCharFont = attribute(.font, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.length)) as? UIFont else { return }
        
        if (firstCharFont.isItalic) {
            unItalic()
        } else {
            italic()
        }
    }
}
