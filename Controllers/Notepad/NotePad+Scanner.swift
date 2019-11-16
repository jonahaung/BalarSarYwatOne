//
//  NotePad+ImagePicker.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 16/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit
import VisionKit
import MobileCoreServices
extension NotePadViewController {
    
    func performScanner() {
        let x = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        x.addAction(buttonText: "Myanmar") { _ in
            self.selectScannType(isMyanar: true)
        }
        x.addAction(buttonText: "English") { _ in
            self.selectScannType(isMyanar: false)
        }
        x.addCancelAction()
        x.show()
    }

    private func selectScannType(isMyanar: Bool) {
        let alert = UIAlertController(title: "Snap/Upload Image", message: nil, preferredStyle: .actionSheet)
        
        if isMyanar {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(buttonText: "Take Photo") { _ in
                    self.activityIndicator.startAnimating()
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    self.present(imagePicker, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                    })
                }
                
            }
        } else {
            alert.addAction(buttonText: "Take Photo") { _ in
                self.activityIndicator.startAnimating()
                let x = VNDocumentCameraViewController()
                x.delegate = self
                self.present(x, animated: true, completion: {
                    self.activityIndicator.stopAnimating()
                })
            }
        }
        
        alert.addAction(buttonText: "Chose Existing Photo") { _ in
            self.activityIndicator.startAnimating()
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: {
                self.activityIndicator.stopAnimating()
            })
        }
        
        
        alert.addCancelAction()
        
        alert.show()
    }
}
extension NotePadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        textView.scrollToBottom(animated: false)
        activityIndicator.startAnimating()
        dismiss(animated: true) {
            self.manager.performImageRecognition(image)
        }
    }
    
    
}

extension NotePadViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        activityIndicator.startAnimating()
        textView.scrollToBottom(animated: false)
        dismiss(animated: true) {
            let images = (0..<scan.pageCount).compactMap({ scan.imageOfPage(at: $0) })
            self.manager.performDocScan(images)
        }
        
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Document camera view controller did finish with error ", error)
        dismiss(animated: true, completion: nil)
    }
}

