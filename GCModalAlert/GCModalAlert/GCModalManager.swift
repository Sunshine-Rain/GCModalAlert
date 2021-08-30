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
    }
    
    open func add(_ modal: Modalable) {
        objc_sync_enter(self)
        modal.triggerDismiss = self.triggerDismiss
        modalObjects.append(modal)
        modalObjects.sort { $0.modalViewConfig.priority > $1.modalViewConfig.priority }
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
        showAnimation(for: modal)
        
        // did show
        modal.modalViewLifecycle.modalViewDidShow?()
    }
    
    open func setupBackgroundViewIfNeeded() {
        assert(UIApplication.shared.keyWindow != nil, "KeybackgroundView not found!")
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        if backgroundView.superview != keyWindow {
            backgroundView.removeFromSuperview()
            backgroundView.frame = keyWindow.bounds
            keyWindow.addSubview(backgroundView)
        }
    }
    
    open func removeBackgroundIfNeeded() {
        if modalObjects.isEmpty {
            backgroundView.removeFromSuperview()
        }
    }
    
    open func getNeedShowModal() -> Modalable? {
        // get the modal view by priority
        guard modalObjects.count > 0 else {
            return nil
            
        }
        return modalObjects.removeFirst()
    }
    
    open func triggerDismiss() {
        objc_sync_enter(self)
        // will dismiss
        currentModal?.modalViewLifecycle.modalViewWillDisappear?()
        
        // animations
        disappearAnimation(for: currentModal)
        
        // did dismiss
        currentModal?.modalView.removeFromSuperview()
        currentModal?.modalViewLifecycle.modalViewDidDisappear?()
        currentModal = nil
        removeBackgroundIfNeeded()
        
        // show next
        showModalIfNeeded()
        
        objc_sync_exit(self)
    }
    
    
    // MARK: Animations
    open func showAnimation(for modal: Modalable) {
        // custom animations
        if modal.modalViewConfig.showAnimationClosure != nil {
            modal.modalViewConfig.showAnimationClosure?(backgroundView, modal)
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
            }
        case .B2T:
            let originFrame = modal.modalView.frame
            let frameBegin = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.backgroundColor = UIColor.clear
            modal.modalView.frame = frameBegin
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                modal.modalView.frame = originFrame
            }
        }
    }
    
    open func disappearAnimation(for modal: Modalable?) {
        guard let modal = modal else {
            return
        }
        
        // custom animations
        if modal.modalViewConfig.dismissAnimationClosure != nil {
            modal.modalViewConfig.dismissAnimationClosure?(backgroundView, modal)
            return
        }
        
        //
        let config = modal.modalViewConfig
        switch config.dismissAnimationType {
        case .fade:
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = .clear
                modal.modalView.alpha = 0.0
            }
        case .T2B:
            let originFrame = modal.modalView.frame
            let frameEnd = CGRect(x: originFrame.origin.x, y: backgroundView.bounds.size.height, width: originFrame.size.width, height: originFrame.size.height)
            
            backgroundView.backgroundColor = UIColor.clear
            UIView.animate(withDuration: config.showAnimationDuration) {
                self.backgroundView.backgroundColor = .clear
                modal.modalView.frame = frameEnd
            }
        }
    }
}
