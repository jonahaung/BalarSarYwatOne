//
//  NotePadTextView.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotePadTextView: UITextView {
    
    private var placeHolderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.placeholderText]
    private var suggestedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.placeholderText]
    
    var suggestedText: String? {
        didSet {
            if oldValue != suggestedText {
                setNeedsDisplay()
            }
        }
    }
    private var suggestedRect = CGRect.zero
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotePadTextView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !text.isEmpty, let suggestedText = self.suggestedText {
            let caretRect = self.caretRect(for: self.endOfDocument)
            
            let size = CGSize(width: rect.width - caretRect.maxX, height: 50)
            let diff = (caretRect.height - self.font!.lineHeight) / 2
            
            let origin = CGPoint(x: caretRect.maxX, y: caretRect.minY + diff)
            suggestedRect = CGRect(origin: origin, size: size)
            
            suggestedText.draw(in: suggestedRect, withAttributes: suggestedTextAttributes)
        }
    }
}

extension NotePadTextView {
    
    
    
    private func setup() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        allowsEditingTextAttributes = false
        keyboardDismissMode = .interactive
        textContainer.lineFragmentPadding += 10
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.1
//        v ndent = 10
        font = UIFont.getDefaultFont()
        var attr = typingAttributes
        attr[.paragraphStyle] = paragraphStyle
        attr[.font] = font
        typingAttributes = attr
        
        dataDetectorTypes = []
        
        suggestedTextAttributes[.paragraphStyle] = {
            $0.lineBreakMode = .byClipping
            return $0
        }(NSMutableParagraphStyle())
        suggestedTextAttributes[.font] = font
    }
    
    

}
