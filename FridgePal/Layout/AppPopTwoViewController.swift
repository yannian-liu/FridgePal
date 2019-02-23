//
//  AppPopDoubleViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 21/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import UIKit

class AppPopTwoViewController: UIViewController {
    
    var isAllowToProgress : Bool = false
    var isStatus1: Bool = true
    
    lazy var panelView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height)
        view.backgroundColor = UIColor.clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(panGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var containerView1: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.frame.size = CGSize(width: UIScreen.main.bounds.width - AppLayoutParameter.marginBig*2, height: AppLayoutParameter.containerHeightMedium)
        containerView.setRoundCornerShape()
        containerView.addShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var containerView2: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.frame.size = CGSize(width: UIScreen.main.bounds.width - AppLayoutParameter.marginBig*2, height: AppLayoutParameter.containerHeightMedium)
        containerView.setRoundCornerShape()
        containerView.addShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var closeButton1: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        let origImage = UIImage(named: "close")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour2Dark
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton2: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        let origImage = UIImage(named: "close")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour2Dark
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    // - - - - - - - - - - - - - - view controller - - - - - - - - - - - - - - //
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // - - - - - - - - - - - - - - set up - - - - - - - - - - - - - - //
    
    func setupPopViewControllerBasic(containerViewHeight: CGFloat){
        view.backgroundColor = UIColor.white
        
        view.addSubview(panelView)
        
        panelView.addSubview(containerView1)
        containerView1.centerYAnchor.constraint(equalTo: panelView.centerYAnchor).isActive = true
        containerView1.leftAnchor.constraint(equalTo: panelView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        containerView1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-AppLayoutParameter.marginBig*2).isActive = true
        containerView1.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        
        panelView.addSubview(containerView2)
        containerView2.centerYAnchor.constraint(equalTo: panelView.centerYAnchor).isActive = true
        containerView2.rightAnchor.constraint(equalTo: panelView.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        containerView2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-AppLayoutParameter.marginBig*2).isActive = true
        containerView2.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        
        setupContainerView1()
        setupContainerView2()
        
    }
    
    func setupContainerView1(){
        containerView1.addSubview(closeButton1)
        let closeButton1Diameter = closeButton1.frame.size.width
        closeButton1.topAnchor.constraint(equalTo: containerView1.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        closeButton1.widthAnchor.constraint(equalToConstant: closeButton1Diameter).isActive = true
        closeButton1.rightAnchor.constraint(equalTo: containerView1.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        closeButton1.heightAnchor.constraint(equalToConstant: closeButton1Diameter).isActive = true
    }
    
    func setupContainerView2(){
        containerView2.addSubview(backButton)
        let backButtonDiameter = closeButton2.frame.size.width
        backButton.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        backButton.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: backButtonDiameter).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: backButtonDiameter).isActive = true
        
        containerView2.addSubview(closeButton2)
        let closeButton2Diameter = closeButton2.frame.size.width
        closeButton2.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        closeButton2.widthAnchor.constraint(equalToConstant: closeButton2Diameter).isActive = true
        closeButton2.rightAnchor.constraint(equalTo: containerView2.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        closeButton2.heightAnchor.constraint(equalToConstant: closeButton2Diameter).isActive = true
    }
    // - - - - - - - - - - - - - - button handler - - - - - - - - - - - - - - //

    @objc func handleCloseButton(){
        if isStatus1 == true {
            containerView1.animatePulse {
                self.navigationController?.popViewController(animated: false)
            }
        } else {
            containerView2.animatePulse {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    @objc func handleBackButton(){
        panelView.animateMovingRight()
        isStatus1 = true
    }
    
    func handleProgress(){
        panelView.animateMovingLeft()
        isStatus1 = false
    }
    
    var isOverBounds = false
    
    @objc func handleGesture(_ gestureRecognizer : UIPanGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            panelView.center = CGPoint(x: panelView.center.x + translation.x, y: panelView.center.y)
            if (gestureRecognizer.view!.center.x > UIScreen.main.bounds.width + AppLayoutParameter.marginBig){
                gestureRecognizer.state = UIGestureRecognizer.State.ended
                isOverBounds = true
            } else if (gestureRecognizer.view!.center.x < -AppLayoutParameter.marginBig){
                gestureRecognizer.state = UIGestureRecognizer.State.ended
                isOverBounds = true
            } else {
                if (gestureRecognizer.view!.center.x < UIScreen.main.bounds.width - AppLayoutParameter.marginSmall){
                    if isAllowToProgress == false {
                        gestureRecognizer.state = UIGestureRecognizer.State.ended
                        isOverBounds = true
                    } else { isOverBounds = false }
                } else { isOverBounds = false }
            }
            gestureRecognizer.setTranslation(CGPoint(x:0,y:0), in: self.view)
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended{
            if panelView.center.x > UIScreen.main.bounds.width/2 {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.panelView.center.x = UIScreen.main.bounds.width
                    }) { _ in
                        if self.isOverBounds == true {
                            self.containerView1.animateShakeLess {}
                        }
                }
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.panelView.center.x = 0
                }) { _ in
                    if self.isOverBounds == true {
                        self.containerView2.animateShakeLess {}
                    }
                }
            }
        }
        
    }
    
}
