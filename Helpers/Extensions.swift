//
//  Extensions.swift
//  MyanmarTypo
//
//  Created by Aung Ko Min on 10/10/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import CoreData

extension Note {

    var language: Language {
        return text?.lastWord.EXT_isEnglishCharacters == true ? .English : .Myanmar
    }
}

// UIImage
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let height = CGFloat(ceil(width / size.width * size.height))
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
// UIBarButtonItem
extension UIBarButtonItem {
    
    static var flexiable: UIBarButtonItem {
        return  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

// Date
extension Date {
    
    var relativeString: String {
        return AppUtilities.dateFormatter_relative.localizedString(for: self, relativeTo: Date())
    }
    var dateString: String {
        return AppUtilities.dateFormatter.string(from: self)
    }
}

// TopViewController
extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = SceneDelegate.sharedInstance?.window?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}

// String
extension Optional where Wrapped == String {
    var emptyIfNil: String {
        return self ?? String()
    }
}

// Coredata
extension NSManagedObjectContext {
    func saveIfHasChanges() {
        if hasChanges {
            do {
                try save()
            }catch { print(error.localizedDescription) }
        }
    }
}

// TableView
extension UITableView {
    
    func setBackgroundImage() {
        backgroundView = UIImageView(image: UIImage(named: traitCollection.userInterfaceStyle == .dark ? "bgD" : "bgL"))
    }
}

extension String {
    func exclude(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.lazy.filter { !set.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }
    func include(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.lazy.filter { set.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }
}


extension CharacterSet {
    
    static let removingCharacters = CharacterSet(charactersIn: "+*#%;:&^$@!~.,'`|_ၤ")
    
    static var myanmarAlphabets: CharacterSet {
        return CharacterSet(charactersIn: "ကခဂဃငစဆဇဈညတဒဍဓဎထဋဌနဏပဖဗဘမယရလ၀သဟဠအဣဧဤဩဥ။")
    }
    static var englishAlphabets: CharacterSet {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ")
    }
    static var lineEnding: CharacterSet {
        return CharacterSet(charactersIn: ".,?!;:။…\n\t")
    }
}
extension String {

    var nsRange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
    
    var myanmarSegments: [String] {
        let regex = RegexParser.regularExpression(for: RegexParser.myanmarWordsBreakerPattern)
        let modString = regex?.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: utf16.count), withTemplate: "𝕊$1")
        return modString?.components(separatedBy: "𝕊").filter{ !$0.isEmpty } ?? self.components(separatedBy: .whitespaces)
    }
}



 extension String {
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }

    var EXT_isMyanmarCharacters: Bool {
        return self.rangeOfCharacter(from: CharacterSet.myanmarAlphabets) != nil
    }
    var EXT_isEnglishCharacters: Bool {
        return self.rangeOfCharacter(from: CharacterSet.englishAlphabets) != nil
    }

    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }

    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    
}

// MARK: - Methods extension String {
    
extension String {
    
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
  
  
     func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    

    
     func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
   
}

extension String {
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard
        let from = range.lowerBound.samePosition(in: utf16),
        let to = range.upperBound.samePosition(in: utf16)
            else { return nil }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from), length: utf16.distance(from: from, to: to))
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func wordParts(_ range: Range<String.Index>) -> (left: String.SubSequence, right: String.SubSequence)? {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        let leftView = self[..<range.upperBound]
        let leftIndex = leftView.rangeOfCharacter(from: whitespace, options: .backwards)?.upperBound
            ?? leftView.startIndex
        
        let rightView = self[range.upperBound...]
        let rightIndex = rightView.rangeOfCharacter(from: whitespace)?.lowerBound
            ?? endIndex
        
        return (leftView[leftIndex...], rightView[..<rightIndex])
    }
    
    func word(at nsrange: NSRange) -> (word: String, range: Range<String.Index>)? {
        guard !isEmpty,
            let range = Range(nsrange, in: self),
            let parts = self.wordParts(range)
            else { return nil }
        
        // if the left-next character is whitespace, the "right word part" is the full word
        // short circuit with the right word part + its range
        if let characterBeforeRange = index(range.lowerBound, offsetBy: -1, limitedBy: startIndex),
            let character = self[characterBeforeRange].unicodeScalars.first,
            NSCharacterSet.whitespaces.contains(character) {
            let right = parts.right
            return (String(right), right.startIndex ..< right.endIndex)
        }
        
        let joinedWord = String(parts.left + parts.right)
        guard !joinedWord.isEmpty else { return nil }
        
        return (joinedWord, parts.left.startIndex ..< parts.right.endIndex)
    }
    
    var firstWord: String {
        return words().first ?? self
    }

    func lastWords(_ max: Int) -> [String] {
        return Array(words().suffix(max))
    }
    var lastWord: String {
        return words().last ?? self
    }
}


extension UIView {

    /// SwifterSwift: Get view's parent view controller
    var EXT_parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    


    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func constraint(equalTo size: CGSize) {
        guard superview != nil else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }

    
    func fillSuperview() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
    func centerInSuperview() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    @discardableResult
    func addConstraints(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        if self.superview == nil {
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: topConstant)
            constraint.identifier = "top"
            constraints.append(constraint)
        }
        
        if let left = left {
            let constraint = leftAnchor.constraint(equalTo: left, constant: leftConstant)
            constraint.identifier = "left"
            constraints.append(constraint)
        }
        
        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            constraint.identifier = "bottom"
            constraints.append(constraint)
        }
        
        if let right = right {
            let constraint = rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            constraint.identifier = "right"
            constraints.append(constraint)
        }
        
        if widthConstant > 0 {
            let constraint = widthAnchor.constraint(equalToConstant: widthConstant)
            constraint.identifier = "width"
            constraints.append(constraint)
        }
        
        if heightConstant > 0 {
            let constraint = heightAnchor.constraint(equalToConstant: heightConstant)
            constraint.identifier = "height"
            constraints.append(constraint)
        }
        
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    func removeAllConstraints() {
        constraints.forEach { removeConstraint($0) }
    }
}
