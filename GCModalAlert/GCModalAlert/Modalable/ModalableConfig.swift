//
//  ModalableConfig.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/30.
//

import UIKit

public typealias ModalableBoolClosure = () -> Bool
public typealias ModalableAnimationClosure = (_ background: UIView, _ modal: Modalable, _ completion: @escaping BoolClosure) -> Void

public struct ModalableConfig {
    public enum DuplicateBehavior {
        case doNothing
        case useLastest
        case ignoreLatest
    }
    
    public static let duration: TimeInterval = 0.25
    
    /// high priority will be present earlier.
    public var priority: Int
    
    public var condition: ModalableBoolClosure?
    
    public var beahviorWhileDuplicate: DuplicateBehavior
    
    public var duplicateIdentifier: String?
    
    public var cancelWhileTapBackground: Bool
    
    public var tapBackgroundClosure: VoidClosure?
    
    public var showAnimationType: ModableShowAnimationType
    
    public var showAnimationDuration: TimeInterval
    
    public var showAnimationClosure: ModalableAnimationClosure?
    
    public var dismissAnimationType: ModableDismissAnimationType
    
    public var dismissAnimationDuration: TimeInterval
    
    public var dismissAnimationClosure: ModalableAnimationClosure?
    
    public init(priority: Int = 0,
                condition: ModalableBoolClosure? = nil,
                beahviorWhileDuplicate: DuplicateBehavior = .ignoreLatest,
                duplicateIdentifier: String? = nil,
                cancelWhileTapBackground: Bool = false,
                tapBackgroundClosure: VoidClosure? = nil,
                showAnimationType: ModableShowAnimationType = .fade,
                showAnimationDuration: TimeInterval = Self.duration,
                showAnimationClosure: ModalableAnimationClosure? = nil,
                dismissAnimationType: ModableDismissAnimationType = .fade,
                dismissAnimationDuration: TimeInterval = Self.duration,
                dismissAnimationClosure: ModalableAnimationClosure? = nil) {
        self.priority = priority
        self.condition = condition
        self.beahviorWhileDuplicate = beahviorWhileDuplicate
        self.duplicateIdentifier = duplicateIdentifier
        self.cancelWhileTapBackground = cancelWhileTapBackground
        self.tapBackgroundClosure = tapBackgroundClosure
        self.showAnimationType = showAnimationType
        self.showAnimationDuration = showAnimationDuration
        self.showAnimationClosure = showAnimationClosure
        self.dismissAnimationType = dismissAnimationType
        self.dismissAnimationDuration = dismissAnimationDuration
        self.dismissAnimationClosure = dismissAnimationClosure
    }
}
