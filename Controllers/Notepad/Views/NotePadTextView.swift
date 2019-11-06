//
//  NotePadTextView.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NotePadTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

extension NotePadTextView {
    
    private func setup() {
        bounces = true
        alwaysBounceVertical = true
        isScrollEnabled = true
        backgroundColor = nil
        allowsEditingTextAttributes = true
        keyboardDismissMode = .none
        insetsLayoutMarginsFromSafeArea = true
        textContainer.lineFragmentPadding += 10
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.firstLineHeadIndent = 30
        paragraphStyle.paragraphSpacing = 10

        font = UIFont.getDefaultFont()
        var attr = typingAttributes
        attr[.paragraphStyle] = paragraphStyle
        attr[.font] = font
        typingAttributes = attr
        
        dataDetectorTypes = []
    }

}
