//
//  Coordintor.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

protocol Navigator {
    func pushTo(_ viewController: UIViewController)
    func popViewController()
}

extension Navigator {
    
    func pushTo(_ viewController: UIViewController) {
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    func popViewController() {
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String?, message: String?) {
        let x = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        UIApplication.topViewController()?.present(x, animated: true)
    }
}
