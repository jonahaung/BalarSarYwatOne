//
//  Git.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 25/2/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

 import UIKit
 import CoreData
 extension UITableView {
 
    var indexPaths: [IndexPath] {
        return (0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [IndexPath] in
            (0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> IndexPath? in
                IndexPath(row: rowIndex, section: sectionIndex)
            }
        }.flatMap { $0 }
    }
    func selectAll() {
        indexPaths.forEach {
            selectRow(at: $0, animated: true, scrollPosition: .none)
        }
    }
 }
 
 extension UICollectionView {
    var indexPaths: [IndexPath] {
        return (0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [IndexPath] in
            (0..<self.numberOfItems(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> IndexPath? in
                IndexPath(row: rowIndex, section: sectionIndex)
            }
        }.flatMap { $0 }
    }
    func selectAll() {
        indexPaths.forEach {
            selectItem(at: $0, animated: true, scrollPosition: .init())
        }
    }
 }
 
extension Note {
//    var language: Language {
//        return text?.lastWord.EXT_isEnglishCharacters == true ? .English : .Myanmar
//    }
}

 extension String {
 
    func cleanUpMyanmarTexts() -> String {
        let words = self.words()
        let filtered = words.filter{RegexParser.regularExpression(for: RegexParser.unicodePattern)!.matches($0 )}
        return TextCorrector.shared.correct(text: filtered.joined(separator: " "))
     }
 }
 
 
 // UIImage
 extension UIImage {
 
    static var title3Configuration: UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)
    }
    static var title1Configuration: UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title1), scale: .large)
    }
    static var title2Configuration: UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title2), scale: .large)
    }
 
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
 
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
 
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
 
        return scaledImage
    }
 }
 
 
 extension UICollectionView {
    func setBackgroundImage() {
        backgroundView = UIImageView(image: UIImage(named: traitCollection.userInterfaceStyle == .dark ? "bgD" : "bgL"))
    }
 }
