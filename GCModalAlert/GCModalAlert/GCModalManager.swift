//
//  GCModaManager.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

open class GCModalManager {
    public static let defaultManager = GCModalManager()
    
    open var modalObjects: [Modalable] = []
    open var backgroundView: UIView
    open var currentModal: Modalable?
    
    
    init(_ bgView: UIView = UIView()) {
        backgroundView = bgView
        
        setupBackgroundGesture()
    }
    
    open func add(_ modal: Modalable) {
        objc_sync_enter(self)
        addModalIfNeeded(modal: modal)
        showModalIfNeeded()
        objc_sync_exit(self)
    }
    
    open func showModalIfNeeded() {
        // if is showing another
        guard currentModal == nil, let modal = getNeedShowModal() else {
            return
        }
        
        // condition testing
        guard modal.modalViewConfig.condition?() ?? true else {
            showModalIfNeeded()
            return
        }
        
        //
        setupBackgroundViewIfNeeded()
        
        // will show
        currentModal = modal
        modal.modalViewLifecycle.modalViewWillShow?()
        backgroundView.addSubview(modal.modalView)
        
        // animations
        showAnimation(for: modal) { _ in
            // did show
            modal.modalViewLifecycle.modalViewDidShow?()
        }
    }
    
    open func setupBackgroundViewIfNeeded() {
        assert(UIApplication.shared.keyWindow != nil, "KeyWindow not found!")
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        if backgroundView.superview != keyWindow {
            backgroundView.removeFromSuperview()
            backgroundView.frame = keyWindow.bounds
            keyWindow.addSubview(backgroundView)
        }
    }
    
    open func setupBackgroundGesture() {
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(actionTap(_:)))
        backgroundView.addGestureRecognizer(tagGesture)
    }
    
    open func removeBackgroundIfNeeded() {
        if modalObjects.isEmpty {
            backgroundView.removeFromSuperview()
        }
    }
    
    open func addModalIfNeeded(modal: Modalable) {
        let config = modal.modalViewConfig
        let currentIdentifier = modal.identifier
        print("The identifier is: \(currentIdentifier)")
        
        // ignoreLatest
        if config.beahviorWhileDuplicate == .ignoreLatest,
           (currentModal?.identifier == currentIdentifier
            || modalObjects.firstIndex(where: { $0.identifier == currentIdentifier }) != nil) {
            return
        }
        
        objc_sync_enter(self)
        // useLastest
        if config.beahviorWhileDuplicate == .useLastest {
            modalObjects.removeAll { currentIdentifier == $0.identifier }
        }
        
        // normal
        modal.triggerDismiss = self.triggerDismiss
        modalObjects.append(modal)
        modalObjects.sort { $0.modalViewConfig.priority > $1.modalViewConfig.priority }
        showModalIfNeeded()
        objc_sync_exit(self)
    }
    
    open func getNeedShowModal() -> Modalable? {
        // get the modal view by priority
        guard modalObjects.count > 0 else {
            return nil
            
        }
        return modalObjects.removeFirst()
    }
    
    open func triggerDismiss() {
        // will dismiss
        currentModal?.modalViewLifecycle.modalViewWillDisappear?()
        
        // animations
        disappearAnimation(for: currentModal) { [weak self] _ in
            if let self = self {
                objc_sync_enter(self)
                // did dismiss
                self.currentModal?.modalView.removeFromSuperview()
                self.currentModal?.modalViewLifecycle.modalViewDidDisappear?()
                self.currentModal = nil
                self.removeBackgroundIfNeeded()
                
                // show next
                self.showModalIfNeeded()
                objc_sync_exit(self)
            }
        }
    }
    
    // MARK: Actions
    @objc open func actionTap(_ sender: Any) {
        guard let current = currentModal else {
            return
        }
        
        current.modalViewConfig.tapBackgroundClosure?()
        if current.modalViewConfig.cancelWhileTapBackground {
            triggerDismiss()
        }
    }
    
    
    // MARK: Animations
    open func showAnimation(for modal: Modalable, completion: @escaping BoolClosure) {
        // custom animations
        if modal.modalViewConfig.showAnimationClosure != nil {
            modal.modalViewConfig.showAnimationClosure?(backgroundView, modal, completion)
            return
        }
        
        //
        let config = modal.modalViewConfig
        switch config.showAnimationType {
        case .fade:
            backgroundView.backgroundColor = UIColor.clear
            modal.modalView.alpha = 0.0
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                modal.modalView.alpha = 1.0
            } completion: { finished in
                completion(finished)
            }
        case .B2T:
            let originFrame = modal.modalView.frame
            let frameBegin = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.backgroundColor = UIColor.clear
            modal.modalView.frame = frameBegin
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                modal.modalView.frame = originFrame
            } completion: { finished in
                completion(finished)
            }
        }
    }
    
    open func disappearAnimation(for modal: Modalable?, completion: @escaping BoolClosure) {
        guard let modal = modal else {
            return
        }
        
        // custom animations
        if modal.modalViewConfig.dismissAnimationClosure != nil {
            modal.modalViewConfig.dismissAnimationClosure?(backgroundView, modal, completion)
            return
        }
        
        //
        let config = modal.modalViewConfig
        switch config.dismissAnimationType {
        case .fade:
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = .clear
                modal.modalView.alpha = 0.0
            } completion: { finished in
                completion(finished)
            }
        case .T2B:
            let originFrame = modal.modalView.frame
            let frameEnd = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.backgroundColor = UIColor.clear
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = .clear
                modal.modalView.frame = frameEnd
            } completion: { finished in
                completion(finished)
            }
        }
    }
}
