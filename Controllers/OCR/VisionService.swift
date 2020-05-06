//
//  VisionService.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import AVKit
import Vision

protocol VisionServiceDelegate: class {
    func service(_ service: VisionService, didOutput textRects: [TextRect], buffer: CVImageBuffer)
}
class VisionService: NSObject {
    weak var delegate: VisionServiceDelegate?
    private var lastTimestamp = CMTime()
    private var fps = 5
}


extension VisionService {
    
    private func detect(_ buffer: CVImageBuffer) {
        let request = VNRecognizeTextRequest { [weak self, weak buffer] (x, _) in
            guard let buffer = buffer, let self = self else { return }
            DispatchQueue.main.async {
                guard let results = x.results as? [VNRecognizedTextObservation] else { return }
                var textRects = [TextRect]()
                
                results.forEach {
                    if let first = $0.topCandidates(1).first {
                        let x = TextRect(text: first.string, rect: $0.boundingBox)
                        textRects.append(x)
                    }
                }
                
                guard textRects.count > 0 else {
                    return
                }
                self.delegate?.service(self, didOutput: textRects, buffer: buffer)
            }

        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .up)
        
        try? handler.perform([request])
    }
}
extension VisionService: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        if CurrentSession.videoSize == .zero {
            CurrentSession.videoSize = CGSize(width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))
        }
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimestamp
        let canPerformRequest = deltaTime >= CMTimeMake(value: 1, timescale: Int32(fps))
        if canPerformRequest {
            
            lastTimestamp = timestamp
            detect(buffer)
        }
    }
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        if CurrentSession.videoSize == .zero {
            CurrentSession.videoSize = CGSize(width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))
        }
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimestamp
        let canPerformRequest = deltaTime >= CMTimeMake(value: 1, timescale: Int32(fps))
        if canPerformRequest {
            lastTimestamp = timestamp
            detect(buffer)
        }
    }
}
