//
//  AppAnimation.swift
//  FridgePal
//
//  Created by Yannian Liu on 3/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    // CATransaction + CABasicAnimation
    func animatePulse (completionBlock: @escaping () -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionBlock()
        })
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.02
        animation.duration = 0.09
        animation.autoreverses = true
        animation.repeatCount = 1
        self.layer.add(animation, forKey: "pulsing")
        CATransaction.commit()
    }
    
    // UIView.animate + transform / CGAffineTransform
    func animatePulseWithDelay(completionBlock: @escaping () -> Void){
        let originTransform = self.transform
        UIView.animate(withDuration: 0.05, delay:0.5, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
                self.transform = originTransform
            }, completion: { _ in
            })
        })
    }
    
    func animatePulsingWithRepeat(){
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
        })
    }
    
    func animatePulsingWithRepeatInCATrasaction(){
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 1.0
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.0;
        scaleAnimation.toValue = 1.2;
        self.layer.add(scaleAnimation, forKey: "scale")
    }
    
    // CATransaction + CABasicAnimation
    func animateShake (completionBock: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionBock()
        })
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        let fromPointSU:CGPoint = CGPoint(x: self.center.x - 5, y: self.center.y)
        let toPointSU:CGPoint = CGPoint(x: self.center.x + 5, y: self.center.y)
        animation.fromValue = NSValue(cgPoint:fromPointSU)
        animation.toValue = NSValue(cgPoint:toPointSU)
        self.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
    
    func animateShakeLess (completionBock: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionBock()
        })
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        let fromPointSU:CGPoint = CGPoint(x: self.center.x - 5, y: self.center.y)
        let toPointSU:CGPoint = CGPoint(x: self.center.x + 5, y: self.center.y)
        animation.fromValue = NSValue(cgPoint:fromPointSU)
        animation.toValue = NSValue(cgPoint:toPointSU)
        self.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
    
    // - - - - - - - - - - - - - - Specials - - - - - - - - - - - - - - //
    
    // for container 1 and container 2
    
    func animateMovingLeft (){
        let originCentre = self.center
        let destinationCentre = CGPoint(x: originCentre.x-UIScreen.main.bounds.width, y:originCentre.y)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut , .allowUserInteraction], animations: {
            self.center = destinationCentre
        }, completion: nil)
    }
    
    func animateMovingRight() {
        let originCentre = self.center
        let destinationCentre = CGPoint(x: originCentre.x+UIScreen.main.bounds.width, y:originCentre.y)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut , .allowUserInteraction], animations: {
            self.center = destinationCentre
        }, completion: nil)
    }
    
    // appear/disappear with animation to right/left with Alpha for detail view tableview delete and edit button
    
    func disappearWithAnimationWithAlphaForTwoView(rightView:UIView, completionBlock: @escaping () -> Void){
        let originX1 = self.center.x
        let originY1 = self.center.y
        let originX2 = rightView.center.x
        let originY2 = rightView.center.y
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut , .allowUserInteraction], animations: {
            self.center = CGPoint(x: originX1-5, y: originY1)
            self.alpha = 0.0
            rightView.center = CGPoint(x: originX2+5, y: originY2)
            rightView.alpha = 0.0

        }, completion: { finished in
            self.isHidden = true
            rightView.isHidden = true
            
            self.center.x = originX1
            self.center.y = originY1
            rightView.center.x = originX2
            rightView.center.y = originY2
            completionBlock()
        })
    }
    
    func appearWithAnimationWithAlphaForTwoView(rightView: UIView, completionBlock: @escaping () -> Void){
        self.alpha = 0.0
        self.isHidden = false
        rightView.alpha = 0.0
        rightView.isHidden = false
        
        let destinationX1 = self.center.x
        let destinationY1 = self.center.y
        self.center.x = self.center.x-5
        let destinationX2 = rightView.center.x
        let destinationY2 = rightView.center.y
        rightView.center.x = rightView.center.x+5
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut , .allowUserInteraction], animations: {
            self.center = CGPoint(x: destinationX1, y: destinationY1)
            self.alpha = 1.0
            rightView.center = CGPoint(x: destinationX2, y: destinationY2)
            rightView.alpha = 1.0
        }, completion: { finished in
            completionBlock()
        })
    }
}
