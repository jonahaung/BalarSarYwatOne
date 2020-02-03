//
//  Ext+UIFont.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

extension UIFont {
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    static let myaFont: UIFont = UIFontMetrics.default.scaledFont(for: UIFont(name: "MyanmarPauklay", size: 17)!)
    func italic() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.insert(.traitItalic)

        return self.buildFont(symTraits: symTraits)
    }
    
    func bold() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.insert(.traitBold)

        return self.buildFont(symTraits: symTraits)
    }
    
    func unBold() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.remove(.traitBold)
        
        return self.buildFont(symTraits: symTraits)
    }
    
    func unItalic() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.remove(.traitItalic)

        return self.buildFont(symTraits: symTraits)
    }
    
    static func getDefaultFont() -> UIFont {
        let defaultFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let fontDescriptor = defaultFontDescriptor.withSymbolicTraits(.classModernSerifs)

        let font: UIFont

        if let fontDescriptor = fontDescriptor {
            font = UIFont(descriptor: fontDescriptor, size: UIFont.labelFontSize)
        } else {
            font = UIFont.preferredFont(forTextStyle: .body)
        }

        return font
    }
    
    public static func bodySize() -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let font = fontMetrics.scaledFont(for: UIFont.preferredFont(forTextStyle: .body))
        
        return font
    }

    private func buildFont(symTraits: UIFontDescriptor.SymbolicTraits?) -> UIFont {
        var font: UIFont

        if let traits = symTraits, let descriptor = fontDescriptor.withSymbolicTraits(traits) {
            font = UIFont(descriptor: descriptor, size: descriptor.pointSize)
        } else {
            font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            font.withSize(fontDescriptor.pointSize)

            return font
        }

        return font
    }
}
