//
//  NotePadManager.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import SwiftyTesseract
import GPUImage
import Vision
import VisionKit

class NotePadManager: NSObject {
    
    weak var delegate: NotePadManagerDelegate?
    let context = PersistanceManager.shared.container.newBackgroundContext()
    let note: Note
    var textView: NotePadTextView? { return delegate?.textView }
    private let swiftyTesseract: SwiftyTesseract = {
//        $0.preserveInterwordSpaces = false
        return $0
    }(SwiftyTesseract(language: .burmese))
    private let queue = DispatchQueue(label: "com.jonahaung.MyanmarTextScanner", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    init(note: Note) {
        self.note = context.object(with: note.objectID) as! Note
        super.init()
    }
    
    deinit {
        context.saveIfHasChanges()
        NotificationCenter.default.removeObserver(self)
        print("Deinit : NotePadManager")
    }
    
    func save() {
        note.text = textView?.text
        note.edited = Date()
    }
    func deleteNote() {
        context.refresh(note, mergeChanges: true)
        context.delete(note)
    }
}

extension NotePadManager: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.textViewDidEndEditing()
    }
    
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}

extension NotePadManager {
    func performImageRecognition(_ image: UIImage) {
        let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
        self.swiftyTesseract.performOCR(on: preprocessedImage) { recognizedString in
            
            let result = recognizedString?.removerCharacters(in: .removingCharacters)
            self.delegate?.didFinishedRecoginingText(recognizedText: result)
        }
    }

    func performDocScan(_ images: [UIImage]) {
        
        queue.async {[weak self] in
            guard let `self` = self else { return }
            let textPerPage: [String]
            let imagesAndRequests = images.map({ (image: $0, request: VNRecognizeTextRequest()) })
            textPerPage = imagesAndRequests.map { image, request -> String in
                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else { return "" }
                    return observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: "\n")
                }
                catch {
                    print(error)
                    return ""
                }
            }
            
            DispatchQueue.main.async {
                textPerPage.forEach{
                    self.delegate?.didFinishedRecoginingText(recognizedText: $0)
                }
            }
        }
    }
}


extension UIImage {
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func preprocessedImage() -> UIImage? {
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 15.0
        
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        return filteredImage
    }
}
