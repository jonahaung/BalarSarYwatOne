//
//  Extensions.swift
//  MyanmarTypo
//
//  Created by Aung Ko Min on 10/10/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import CoreData

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
