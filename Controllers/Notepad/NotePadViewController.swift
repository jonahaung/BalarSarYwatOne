//
//  NotePadViewController.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 2/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit


final class NotePadViewController: UIViewController, Navigator {
    
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? { return bar }

    let backgroundImageView: UIImageView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return $0
    }(UIImageView())
    
    let textView = NotePadTextView()
    let activityIndicator: UIActivityIndicatorView = {
        $0.color = UIColor.systemRed
        $0.style = .large
        $0.hidesWhenStopped = true
        $0.sizeToFit()
        return $0
    }(UIActivityIndicatorView())
    
    let bar: UIToolbar = {
        $0.clipsToBounds = true
        $0.setShadowImage(UIImage(), forToolbarPosition: .any)
        $0.isTranslucent = true
        $0.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 44)
        $0.tintColor = UIColor.systemRed
        return $0
    }(UIToolbar())
    
    let note: Note
    lazy var manager = NotePadManager(note: note)
    
    
    // Init
    init(note: Note) {
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
        
        setDefaultToolbar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
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
    // Editing
    private func setEditingToolbar() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone(_:)))
        let items = [UIBarButtonItem.flexiable, done]
        bar.setItems(items, animated: false)
    }
    // Default
    private func setDefaultToolbar() {
        let pencil = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(didTapEdit(_:)))
        let handWriting = UIBarButtonItem(image: UIImage(systemName: "pencil.and.outline"), style: .plain, target: self, action: #selector(didTapHandWriting(_:)))
        let trash = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapTrash(_:)))
        let camera = UIBarButtonItem(image: UIImage(systemName: "doc.text.viewfinder"), style: .plain, target: self, action: #selector(didTapViewFinder(_:)))
        let items = [trash, UIBarButtonItem.flexiable, camera, handWriting, pencil]
        bar.setItems(items, animated: false)
    }
    
    @objc private func didTapEdit(_ sender: UIBarButtonItem?) {
        textView.becomeFirstResponder()
        textView.ensureCaretToTheEnd()
    }
    
    @objc private func didTapTrash(_ sender: UIBarButtonItem?) {
        manager.deleteNote()
        popViewController()
    }
    
    @objc private func didTapDone(_ sender: UIBarButtonItem?) {
        textView.resignFirstResponder()
        manager.save()
        
    }
    
    @objc private func didTapViewFinder(_ sender: UIBarButtonItem?) {
        textView.resignFirstResponder()
        performScanner()
        
    }
    @objc private func didTapHandWriting(_ sender: UIBarButtonItem?) {
        textView.resignFirstResponder()
        
        
    }
}

// Manager Delegate
extension NotePadViewController: NotePadManagerDelegate {
    
    func didFinishedRecoginingText(recognizedText: String?) {
        activityIndicator.stopAnimating()
        textView.insertText(recognizedText ?? "")
        textView.ensureCaretToTheEnd()
    }
    
    
    func textViewDidEndEditing() {
        setDefaultToolbar()
    }
    
    func textViewDidBeginEditing() {
        setEditingToolbar()
    }
}

// Setup
extension NotePadViewController {
    
    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        title = note.title
        
        updateBackgroundImages()
        backgroundImageView.frame = view.bounds
        view.insertSubview(backgroundImageView, at: 0)
        
        textView.frame = view.bounds
        view.addSubview(textView)
        view.addSubview(activityIndicator)
    }
    
    private func updateBackgroundImages() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        backgroundImageView.image = UIImage(named: isDark ? "bgD" : "bgL")
        bar.setBackgroundImage(UIImage(named: isDark ? "navBarD" : "navBarL"), forToolbarPosition: .any, barMetrics: .default)
    }
    
    private func setupManager() {
        textView.text = note.text
        textView.delegate = manager
        manager.delegate = self
    }
    
}


// Keyboard

extension NotePadViewController {
    
    private func setupKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        guard
            let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let superView = textView.superview
        else { return }
        let isHiding = notification.name == UIResponder.keyboardWillHideNotification
        
        
        let keyboardScreenEndFrame = endValue.cgRectValue
        let keyboardViewEndFrame = textView.convert(keyboardScreenEndFrame, from: superView)
        
        guard textView.contentSize.height > textView.bounds.height-(max(textView.contentInset.bottom, keyboardViewEndFrame.height)) else { return }
        
        
        var contentInset = textView.contentInset
        contentInset.bottom = bottomSpaceFromInputBar()
        var scrollIndicatorInsets = textView.verticalScrollIndicatorInsets
        scrollIndicatorInsets.bottom = textView.contentInset.bottom
        UIView.animate(withDuration: 0.4, animations: {
            self.textView.contentInset = contentInset
            self.textView.verticalScrollIndicatorInsets = scrollIndicatorInsets
        }) { _ in
            
        }
        
//        textView.scrollToBottom(animated: true)
    }
    
    func bottomSpaceFromInputBar() -> CGFloat {
        let trackingViewRect = view.convert(bar.bounds, from: bar).integral
        return max(0, view.bounds.height - trackingViewRect.maxY)
    }

}
