//
//  ViewController.swift
//  GCModalAlertDemo
//
//  Created by quan on 2021/8/27.
//

import UIKit
import GCModalAlert

@inline(__always) func kScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

class ViewController: UIViewController {
    
    var modal: GCBaseModalAlert!
    
    var modal2: GCBaseModalAlert!
    
    var modal3: GCBaseModalAlert!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let attentions = UILabel(frame: .init(x: 0, y: 0, width: 100, height: 40))
        attentions.text = "attentions"
        view.addSubview(attentions)
        
        let frame = CGRect(x: (kScreenWidth() - 200) / 2, y: 100, width: 200, height: 320)
        let lifecycle = ModalableLifecycle {
            print("willShow ..")
        } didShow: {
            print("didShow ..")
        } willDisappear: {
            print("willDisappear ..")
        } didDisappear: {
            print("didDisappear ..")
        }

        
        
        modal = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal.backgroundColor = .orange
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal.addGestureRecognizer(tap)
        
        
        modal3 = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal3.backgroundColor = .cyan
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal3.addGestureRecognizer(tap3)
        modal3.modalViewConfig.duplicateIdentifier = "modal3"
        
        modal2 = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal2.backgroundColor = .green
        modal2.modalViewConfig = ModalableConfig(priority: 10,
                                                 condition: {
                                                    return 1 > 0
                                                 },
                                                 beahviorWhileDuplicate: .useLastest,
                                                 duplicateIdentifier: "000000",
        showAnimationType: .B2T, showAnimationClosure: { bg, modal, completion  in
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = NSNumber.init(value: 1.2)
            animation.toValue = NSNumber.init(value: 1.0)
            animation.duration = 0.25
            
            modal.modalView.layer.add(animation, forKey: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                completion(true)
            }
        }, dismissAnimationType: .T2B)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal2.addGestureRecognizer(tap2)
    
        
        DispatchQueue.main.async {
//            GCModalManager.defaultManager.add(self.modal)
//            GCModalManager.defaultManager.add(self.modal3)
//            GCModalManager.defaultManager.add(self.modal2)
            
//            print(UIApplication.shared.keyWindow)
            
            
            let mx = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
            mx.backgroundColor = .green
            mx.modalViewConfig = ModalableConfig(priority: 10,
                                                     condition: {
                                                        return 1 > 0
                                                     },
                                                     beahviorWhileDuplicate: .useLastest,
                                                     duplicateIdentifier: "000000",
                                                     cancelWhileTapBackground: true,
                                                     tapBackgroundClosure: {
                                                        print("我点击了背景图")
                                                     },
            showAnimationType: .B2T, showAnimationClosure: { bg, modal, completion  in
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = NSNumber.init(value: 1.2)
                animation.toValue = NSNumber.init(value: 1.0)
                animation.duration = 0.25
                
                modal.modalView.layer.add(animation, forKey: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    completion(true)
                }
            }, dismissAnimationType: .T2B)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.dismissAction(sender:)))
            mx.addGestureRecognizer(tap2)
            
            GCModalManager.defaultManager.add(mx)
        }
    }
    
    @objc func dismissAction(sender: UITapGestureRecognizer) {
//        (sender.view as! Modalable).triggerDismiss?()
    }

}

