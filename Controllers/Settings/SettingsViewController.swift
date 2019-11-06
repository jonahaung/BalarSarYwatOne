//
//  SettingsViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let backgroundImageView: UIImageView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(UIImageView())
    
    override func loadView() {
        view = backgroundImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setBackgroundImage()
        }
    }

}
extension SettingsViewController {
    private func setup() {
        navigationItem.title = "Settings"
        
        setBackgroundImage()
    
    }
    
    
    private func setBackgroundImage() {
        let imageName = traitCollection.userInterfaceStyle == .dark ? "bgD" : "bgL"
        backgroundImageView.image = UIImage(named: imageName)
    }
}
