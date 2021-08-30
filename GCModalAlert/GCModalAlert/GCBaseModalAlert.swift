//
//  GCBaseModalView.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

open class GCBaseModalAlert: UIView, Modalable {
    open var modalView: UIView {
        return self
    }
    
    open var modalViewLifecycle: ModalableLifecycleType
    
    open var modalViewConfig: ModalableConfig = ModalableConfig()
    
    open var triggerDismiss: VoidClosure!
    
    
    
    public init(frame: CGRect = .zero, lifecycle: ModalableLifecycle = ModalableLifecycle()) {
        self.modalViewLifecycle = lifecycle
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        self.modalViewLifecycle = ModalableLifecycle()
        super.init(coder: coder)
    }
   
}
