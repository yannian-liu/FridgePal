//
//  AppPushViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 10/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

extension UIViewController {
    func pushAppPopViewController(viewControllerPushed: AppPopViewController){
        guard let aSnapshotView = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: false) else {
            return
        }
        aSnapshotView.addBlurEffect()
        viewControllerPushed.view.insertSubview(aSnapshotView, at: 0)
        navigationController?.pushViewController(viewControllerPushed, animated: false)
        viewControllerPushed.containerView.animatePulse{}
    }
    
    func pushAppPopTwoViewController(viewControllerPushed: AppPopTwoViewController){
        guard let aSnapshotView = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: false) else {
            return
        }
        aSnapshotView.addBlurEffect()
        viewControllerPushed.view.insertSubview(aSnapshotView, at: 0)
        navigationController?.pushViewController(viewControllerPushed, animated: false)
        viewControllerPushed.containerView1.animatePulse{}
    }
    
    func showAlertWithCancel(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // title and message: font and color
        var attributedTitle = NSMutableAttributedString()
        attributedTitle = NSMutableAttributedString(string: title as String, attributes: [NSAttributedString.Key.font: UIFont.appFontBodyMedium!])
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appColour2Dark, range: NSRange(location:0,length:title.count))
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        
        var attributedMessage = NSMutableAttributedString()
        attributedMessage = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font: UIFont.appFontFootnote!])
        attributedMessage.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appColour2Dark, range: NSRange(location:0,length:message.count))
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // buttons: color, not font
        alertController.view.tintColor = UIColor.appColour2Medium  // change text color of the buttons
        
        let cancelAction = UIAlertAction(title: "Go back", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithCancelAndContinue(title: String, message: String, handlerForCancelButton: @escaping () -> Void, handlerForContinueButton: @escaping () -> Void ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // title and message: font and color
        var attributedTitle = NSMutableAttributedString()
        attributedTitle = NSMutableAttributedString(string: title as String, attributes: [NSAttributedString.Key.font: UIFont.appFontBodyMedium!])
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appColour2Dark, range: NSRange(location:0,length:title.count))
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        
        var attributedMessage = NSMutableAttributedString()
        attributedMessage = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font: UIFont.appFontSubhead!])
        attributedMessage.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appColour2Dark, range: NSRange(location:0,length:message.count))
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // buttons: color, not font
        alertController.view.tintColor = UIColor.appColour2Medium  // change text color of the buttons

        
        let cancelAction = UIAlertAction(title: "Go back", style: .cancel){ (_) in
            handlerForCancelButton()
        }
        alertController.addAction(cancelAction)
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (_) in
            handlerForContinueButton()
        }
        alertController.addAction(continueAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
