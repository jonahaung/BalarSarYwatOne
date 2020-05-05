//
//  CameraView.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraView: UIView {
    
    override class var layerClass: AnyClass { return AVCaptureVideoPreviewLayer.self }
    var cameraLayer: AVCaptureVideoPreviewLayer { return layer as! AVCaptureVideoPreviewLayer }

    private var shapeLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTransform()
    }
}

extension CameraView {
    
    private func updateTransform() {
        let videoRect = CGRect(origin: .zero, size: CurrentSession.videoSize)
        let visible = videoRect.intersection(frame)
        let scaleT = CGAffineTransform(scaleX: visible.width, y: -visible.height)
        let translateT = CGAffineTransform(translationX: visible.minX, y: visible.maxY)
        CurrentSession.cameraTransform = scaleT.concatenating(translateT)
    }
    
    
    func configure(_ textRects: [TextRect]) {
        if shapeLayer.path == nil {
            updateTransform()
        }
        let rect = textRects.map{ $0.rect }.reduce(CGRect.null, {$0.union($1)}).applying(CurrentSession.cameraTransform).integral
        let path = CGPath(rect: rect, transform: nil)
        shapeLayer.path = path
        let animation: CABasicAnimation = {
            $0.duration = 0.3
            return $0
        }(CABasicAnimation())
        shapeLayer.add(animation, forKey: "path")
    }
    
    private func setup() {
        shapeLayer = {
            $0.fillColor = nil
            $0.strokeColor = UIColor.systemOrange.cgColor
            $0.lineWidth = 2
            return $0
        }(CAShapeLayer())
        
        layer.addSublayer(shapeLayer)
    }
}
