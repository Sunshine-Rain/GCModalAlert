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
        
        modal2 = GCBaseModalAlert(frame: frame, lifecycle: lifecycle)
        modal2.backgroundColor = .green
        modal2.modalViewConfig = ModalableConfig(priority: 10, condition: {
            return 1 > 0
        }, showAnimationType: .B2T, dismissAnimationType: .T2B)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(dismissAction(sender:)))
        modal2.addGestureRecognizer(tap2)
        
        DispatchQueue.main.async {
            GCModalManager.defaultManager.add(self.modal)
            GCModalManager.defaultManager.add(self.modal3)
            GCModalManager.defaultManager.add(self.modal2)
            
//            print(UIApplication.shared.keyWindow)
        }
    }
    
    @objc func dismissAction(sender: UITapGestureRecognizer) {
        (sender.view as! Modalable).triggerDismiss?()
    }

}

