//
//  ImageScannerController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ImageScannerControllerDelegate: NSObjectProtocol {

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults)
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController)
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error)
}

public final class ImageScannerController: UINavigationController {
    
    weak public var imageScannerDelegate: ImageScannerControllerDelegate?
    
    public required init(image: UIImage? = nil, delegate: ImageScannerControllerDelegate? = nil) {
        super.init(rootViewController: ScannerViewController())
        
        self.imageScannerDelegate = delegate

        if let image = image {
            
            var detectedQuad: Quadrilateral?
        
            guard let ciImage = CIImage(image: image) else { return }
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let orientedImage = ciImage.oriented(forExifOrientation: Int32(orientation.rawValue))
            VisionRectangleDetector.rectangle(forImage: ciImage, orientation: orientation) { (quad) in
                detectedQuad = quad?.toCartesian(withHeight: orientedImage.extent.height)
                let editViewController = EditScanViewController(image: image, quad: detectedQuad, rotateImage: false)
                self.setViewControllers([editViewController], animated: true)
            }
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    internal func flashToBlack() {
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
