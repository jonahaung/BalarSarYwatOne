//
//  NotePadViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

final class NotePadViewController: UIViewController, Navigator, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    enum ActionType {
        case OpenCameraScanner, OpenPhotoScanner, None
    }
    let backgroundImageView: UIImageView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(UIImageView())
    
    let textView = NotePadTextView()
    
    let bar: UIToolbar = {
        $0.clipsToBounds = true
        $0.setShadowImage(UIImage(), forToolbarPosition: .any)
        $0.isTranslucent = true
        $0.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 44)
        $0.tintColor = UIColor.systemRed
        return $0
    }(UIToolbar())
    
    let activityIndicator: UIActivityIndicatorView = {
        $0.style = .large
        $0.hidesWhenStopped = true
        $0.sizeToFit()
        return $0
    }(UIActivityIndicatorView())
    
    var note: Note? {
        didSet {
            userDefaults.updateObject(for: userDefaults.lastOpenedNote, with: note?.title)
            title = note?.title
        }
    }
    lazy var manager = NotePadManager(note: note)
    
    // Init
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObserver()
        print("DEINIT - NotePadViewController")
    }
    
    
    // View Heriercy
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.inputAccessoryView = bar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
    
    
    // Trait Collections
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateBackgroundImages()
        }
    }
}

// Toolbars
extension NotePadViewController {
    
    func startAction(actionType: ActionType) {
        switch actionType {
        case .OpenCameraScanner:
            didTapScanCamera(nil)
        case .OpenPhotoScanner:
            didTapScanDocuments(nil)
        default:
            break
        }
    }
    
    @objc private func didTapAction(_ sender: UIBarButtonItem?) {
        let actionSheet = UIAlertController(title: "Would you like to scan an image or select one from your photo library?", message: nil, preferredStyle: .actionSheet)
        
        let scanAction = UIAlertAction(title: "Scan", style: .default) { (_) in
            //            self.scanImage()
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { (_) in
            //            self.selectImage()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(scanAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    @objc private func didTapEdit(_ sender: UIBarButtonItem?) {
        textView.becomeFirstResponder()
        textView.ensureCaretToTheEnd()
    }
    
    @objc private func didTapMenu(_ sender: UIBarButtonItem?) {
        let sheet = UIAlertController(title: "Would you like to scan an image or select one from your photo library?", message: nil, preferredStyle: .actionSheet)
        
        let scanAction = UIAlertAction(title: "Scan", style: .default) { (_) in
            //            self.scanImage()
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { (_) in
            //            self.selectImage()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(scanAction)
        sheet.addAction(selectAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
        
    }
    
    @objc private func didTapDone(_ sender: UIBarButtonItem?) {
        textView.resignFirstResponder()
        manager.save()
        
    }
    
    @objc private func askLanguage(_ completion: @escaping (_ isMyanmar: Bool) -> Void) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        sheet.addAction(buttonText: "Scan Burmese Texts") { _ in
            completion(true)
        }
        sheet.addAction(buttonText: "Scan Non-Burmese Texts") { _ in
            completion(false)
        }
        sheet.addCancelAction()
        sheet.show()
    }
    @objc private func didTapScanCamera(_ sender: UIBarButtonItem?) {
        let vc = OcrViewController()
        vc.manager.delegate = self
        present(vc, animated: true, completion: nil)
    }
    @objc private func didTapResegment(_ sender: UIBarButtonItem?) {
        textView.text = textView.text.components(separatedBy: .newlines).joined(separator: "\n")
    }
    @objc private func didTapScanDocuments(_ sender: UIBarButtonItem?) {
        askLanguage { (isMyanmar) in
            self.manager.isMyanmar = isMyanmar
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .fullScreen
//            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
    }
    
}

extension NotePadViewController: OcrManagerDelegate {
    func ocrService(_ service: OcrService, didDetect text: String) {
        guard let vc = service.cameraView.EXT_parentViewController else { return }
        vc.dismiss(animated: true, completion: {
            self.textView.insertText("\n" + text)
        })
        
    }
    
    
}

// Manager Delegate
extension NotePadViewController: NotePadManagerDelegate {
    
    func notePadManager(_ manager: NotePadManager, didCreateNew note: Note) {
        self.note = note
        navigationItem.title = note.title
    }
    func textViewDidEndEditing() {
        
    }
    
    func textViewDidBeginEditing() {
        
    }
}

// Setup
extension NotePadViewController {
    
    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction(_:)))
        
        updateBackgroundImages()
        backgroundImageView.frame = view.bounds
        view.insertSubview(backgroundImageView, at: 0)
        
        textView.frame = view.bounds
        view.addSubview(textView)
        
        let pencil = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)), style: .plain, target: self, action: #selector(didTapEdit(_:)))
        
        let trash = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapMenu(_:)))
        let scanCamera = UIBarButtonItem(image: UIImage(systemName: "camera.viewfinder", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)), style: .plain, target: self, action: #selector(didTapScanCamera(_:)))
        let scanDocuments = UIBarButtonItem(image: UIImage(systemName: "doc.text.viewfinder", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)), style: .plain, target: self, action: #selector(didTapScanDocuments(_:)))
        
        let resegment = UIBarButtonItem(image: UIImage(systemName: "decrease.indent", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .title3), scale: .large)), style: .plain, target: self, action: #selector(didTapResegment(_:)))
        let items = [trash, resegment, UIBarButtonItem.flexiable, scanDocuments, scanCamera, pencil]
        navigationController?.setToolbarHidden(false, animated: true)
        toolbarItems = items
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone(_:)))
        let barItems = [UIBarButtonItem.flexiable, done]
        bar.setItems(barItems, animated: false)
        
        
    }
    
    private func updateBackgroundImages() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        backgroundImageView.image = UIImage(named: isDark ? "bgD" : "bgL")
        bar.setBackgroundImage(UIImage(named: isDark ? "navBarD" : "navBarL"), forToolbarPosition: .any, barMetrics: .default)
    }
    
    private func setupManager() {
        textView.text = note?.text
        textView.delegate = manager
        manager.delegate = self
    }
    
}


// Keyboard

extension NotePadViewController {
    
    private func setupKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        let isHiding = notification.name == UIResponder.keyboardWillHideNotification
        var contentInset = textView.contentInset
        contentInset.bottom = isHiding ? 0 : bottomSpaceFromInputBar()
        textView.contentInset = contentInset
        textView.scrollToBottom(animated: true)
    }
    
    func bottomSpaceFromInputBar() -> CGFloat {
        let trackingViewRect = view.convert(bar.bounds, from: bar).integral
        return view.bounds.height - trackingViewRect.maxY
    }
    
}


// Loading Indicator
extension NotePadViewController {
//    private func showLoding() {
//        guard let window = SceneDelegate.sharedInstance?.window else { return }
//
//        activityIndicator.removeFromSuperview()
//        activityIndicator.center = window.center
//        window.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//    }
//
//    func hideLoading() {
//        activityIndicator.stopAnimating()
//        activityIndicator.removeFromSuperview()
//    }
}
