//
//  Modalable.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import UIKit

public protocol Modalable: AnyObject {
    var modalView: UIView { get }
    var modalViewLifecycle: ModalableLifecycleType { get }
    var modalViewConfig: ModalableConfig { get }
    
    // modal alert need call this closure
    var triggerDismiss: VoidClosure! { get set }
}
