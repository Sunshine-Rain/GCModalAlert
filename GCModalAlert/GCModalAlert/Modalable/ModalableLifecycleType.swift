//
//  ModalableLifecycleType.swift
//  GCModalAlert
//
//  Created by quan on 2021/8/27.
//

import Foundation

public typealias VoidClosure = () -> Void

public protocol ModalableLifecycleType {
    var modalViewWillShow: VoidClosure? { get }
    var modalViewDidShow: VoidClosure? { get }
    var modalViewWillDisappear: VoidClosure? { get }
    var modalViewDidDisappear: VoidClosure? { get }
}


public struct ModalableLifecycle: ModalableLifecycleType {
    public var modalViewWillShow: VoidClosure? = nil
    public var modalViewDidShow: VoidClosure? = nil
    public var modalViewWillDisappear: VoidClosure? = nil
    public var modalViewDidDisappear: VoidClosure? = nil
    
    public init(willShow: VoidClosure? = nil, didShow: VoidClosure? = nil, willDisappear: VoidClosure? = nil, didDisappear: VoidClosure? = nil) {
        modalViewWillShow = willShow
        modalViewDidShow = didShow
        modalViewWillDisappear = willDisappear
        modalViewDidDisappear = didDisappear
    }
}
