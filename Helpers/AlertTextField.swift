//
//  AlertTextField.swift
//  MyanmarTypo
//
//  Created by Aung Ko Min on 28/10/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func addOneTextField() -> UITextField {
        let textField = OneTextFieldViewController()
       
        let height: CGFloat = OneTextFieldViewController.ui.height + OneTextFieldViewController.ui.vInset
        set(vc: textField, height: height)
        return textField.textField
    }
}

final class OneTextFieldViewController: UIViewController {
    
    lazy var textField = TextField()
    
    struct ui {
        static let height: CGFloat = 44
        static let hInset: CGFloat = 15
        static var vInset: CGFloat = 15
    }
    
    
    deinit {
        print("Deinit - One Text Field")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// have to set textField frame width and height to apply cornerRadius
        textField.frame.size.height = ui.height
        textField.frame.size.width = view.frame.size.width
        textField.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        preferredContentSize.height = ui.height + ui.vInset
        
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.quaternarySystemFill
        
        view.addSubview(textField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame.size.width = view.frame.size.width - ui.hInset * 2
        textField.frame.size.height = ui.height
        textField.center.x = view.center.x
        textField.center.y = view.center.y - ui.vInset / 2
        
        
    }
}

open class TextField: UITextField {
    // Provides left padding for images
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftViewPadding
        return textRect
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftTextPadding + (leftView?.frame.width ?? 0) + leftViewPadding, dy: 0)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftTextPadding + (leftView?.frame.width ?? 0) + leftViewPadding, dy: 0)
    }
    
    
    public var leftViewPadding: CGFloat = 10
    public var leftTextPadding: CGFloat = 10

}



extension UITextField {
    

    func left(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(image: image)
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    func right(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(image: image)
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
}

// MARK: - Methods

public extension UITextField {
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    /// Set placeholder text and its color
    func placeholder(text value: String, color: UIColor = .red) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedString.Key.foregroundColor : color])
    }
}

extension UIAlertController {
    func show(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(self, animated: true, completion: completion)
            
        }
    }
    
    func set(vc: UIViewController?, width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    func addCancelAction(action: ((UIAlertAction)->Void)? = nil) {

        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: action))
    }
    func addContinueAction(action: @escaping (UIAlertAction)->Void) {

        addAction(UIAlertAction(title: "Continue", style: .default, handler: action))
    }
    
    func addAction(buttonText: String, action: @escaping (UIAlertAction)->Void) {

        addAction(UIAlertAction(title: buttonText, style: .default, handler: action))
    }
}


