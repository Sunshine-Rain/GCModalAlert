//
//  ModalableConfig.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/30.
//

import UIKit

public typealias ModalableBoolClosure = () -> Bool
public typealias ModalableAnimationClosure = (_ background: UIView, _ modal: Modalable) -> Void

public struct ModalableConfig {
    public static let duration: TimeInterval = 0.25
    
    /// high priority will be present earlier.
    public var priority: Int
    
    public var condition: ModalableBoolClosure?
    
    public var showAnimationType: ModableShowAnimationType
    
    public var showAnimationDuration: TimeInterval
    
    public var showAnimationClosure: ModalableAnimationClosure?
    
    public var dismissAnimationType: ModableDismissAnimationType
    
    public var dismissAnimationDuration: TimeInterval
    
    public var dismissAnimationClosure: ModalableAnimationClosure?
    
    public init(priority: Int = 0,
                condition: ModalableBoolClosure? = nil,
                showAnimationType: ModableShowAnimationType = .fade,
                showAnimationDuration: TimeInterval = Self.duration,
                showAnimationClosure: ModalableAnimationClosure? = nil,
                dismissAnimationType: ModableDismissAnimationType = .fade,
                dismissAnimationDuration: TimeInterval = Self.duration,
                dismissAnimationClosure: ModalableAnimationClosure? = nil) {
        self.priority = priority
        self.condition = condition
        self.showAnimationType = showAnimationType
        self.showAnimationDuration = showAnimationDuration
        self.showAnimationClosure = showAnimationClosure
        self.dismissAnimationType = dismissAnimationType
        self.dismissAnimationDuration = dismissAnimationDuration
        self.dismissAnimationClosure = dismissAnimationClosure
    }
}
