//
//  OcrManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 5/5/20.
//  Copyright © 2020 Aung Ko Min. All rights reserved.
//

import AVFoundation
import UIKit

protocol OcrManagerDelegate: class {
    func ocrService(_ service: OcrService, didDetect text: String)
}
final class OcrService: ObservableObject, ItemFactory {
    
    weak var delegate: OcrManagerDelegate?
    let cameraView = CameraView()
    private let videoService = VideoService()
    let visionService = VisionService()
    private var currentResults = [TextRect]()
    private var currentBuffer: CVImageBuffer?
    
    @Published var isMyanmar = userDefaults.isMyanar {
        willSet {
            
            objectWillChange.send()
        }
    }
    func didAppear() {
        videoService.setup(service: self)
        visionService.delegate = self
    }
    
    func capture() {
        guard currentResults.count > 0 else { return }
        setLoading(true)
        
        if isMyanmar {
            videoService.stop()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                if let buffer = self.currentBuffer {
                    let ciImage = buffer.ciImage
                    guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return }
                    let uiImage = UIImage(cgImage: cgImage)
                    OCRManager.shared.detectMyanmarTexts(for: uiImage) { [weak self] x in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            
                            if let texts = x?.cleanUpMyanmarTexts() {
                                self.delegate?.ocrService(self, didDetect: texts)
                            }
                            setLoading(false)
                        }
                    }
                }
            }
        }else {
            let texts = currentResults.map{ $0.text }.compactMap{ $0 }
            
            let text = texts.joined(separator: " ")
            delegate?.ocrService(self, didDetect: text)
            setLoading(false)
        }
    }
}

extension OcrService: VisionServiceDelegate {
    
    func service(_ service: VisionService, didOutput textRects: [TextRect], buffer: CVImageBuffer) {
        cameraView.configure(textRects)
        currentResults = textRects
        currentBuffer = buffer
    }
}

extension OcrService {
    func toggleIsMyanmar() {
        userDefaults.isMyanar.toggle()
        isMyanmar = userDefaults.isMyanar
    }
}
