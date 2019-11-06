//
//  NavigationController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 1/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    let backgroundImageView: UIImageView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setBackgroundImage()
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
        
        setBackgroundImage()
        setBarImage()
        
        backgroundImageView.frame = view.bounds
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    private func setBackgroundImage() {
        let imageName = traitCollection.userInterfaceStyle == .dark ? "bgD" : "bgL"
        backgroundImageView.image = UIImage(named: imageName)
    }
    
    private func setBarImage() {
        let imageName = traitCollection.userInterfaceStyle == .dark ? "navBarD" : "navBarL"
        navigationBar.setBackgroundImage(UIImage(named: imageName), for: .default)
        toolbar.setBackgroundImage(UIImage(named: imageName), forToolbarPosition: .any, barMetrics: .default)
    }
}
