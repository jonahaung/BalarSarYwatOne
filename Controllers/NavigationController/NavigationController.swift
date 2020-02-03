//
//  NavigationController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 1/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setBarImage()
        }
    }
}

extension NavigationController {
    
    private func setup(){
        navigationBar.prefersLargeTitles = true
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        setBarImage()

    }

    private func setBarImage() {
        let imageName = traitCollection.userInterfaceStyle == .dark ? "navBarD" : "navBarL"
        navigationBar.setBackgroundImage(UIImage(named: imageName), for: .default)
        toolbar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
    }
}
