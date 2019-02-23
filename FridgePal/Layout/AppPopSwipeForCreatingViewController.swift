//
//  AppPopSwipeViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 25/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class AppPopSwipeForCreatingViewController: AppPopViewController, UITextFieldDelegate {
    var imageViewLeftConstraint : NSLayoutConstraint? = nil
    var sheetView1LeftConstraint: NSLayoutConstraint? = nil
    var sheetView2LeftConstraint: NSLayoutConstraint? = nil
    
    var isStatus1 : Bool = true
    var isAllowToProgress : Bool = false
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width: AppLayoutParameter.imageHeightSmall*1.5, height: AppLayoutParameter.imageHeightSmall*1.3)
        view.setRoundShape()
        view.image = UIImage(named: "emptyWithQMark")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true // remember to do this, otherwise image views by default are not interactive
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapImageView)))
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.appFontTitle2
        textField.textColor = UIColor.appColour2Medium
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.frame.size = CGSize(width: UIScreen.main.bounds.size.width - AppLayoutParameter.marginBig*2, height: AppLayoutParameter.textFieldHeight)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.textAlignment = .center
        textField.underlined(color:UIColor.appColour2Dark, width: AppLayoutParameter.borderWidth)
        textField.tintColor = UIColor.appColour2Medium
        textField.delegate = self
        return textField
    }()
    
    let sheetView1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let sheetView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        let origImage = UIImage(named: "back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour2Dark
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        if isAllowToProgress == true {
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            button.alpha = 0
        }
        return button
    }()
    
    func setupPopSwipeForCreatingViewControllerBasic(){
        
        containerView.addSubview(backButton)
        let backButtonDiameter = backButton.frame.size.width
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        backButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: backButtonDiameter).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: backButtonDiameter).isActive = true
        
        // - - - - - part 1 - sheet view 2 - - - - - //

        containerView.addSubview(sheetView2)
        sheetView2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:AppLayoutParameter.marginSmall).isActive = true
        sheetView2LeftConstraint = sheetView2.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: containerView.frame.size.width+AppLayoutParameter.marginSmall*2)
        sheetView2LeftConstraint?.isActive = true
        sheetView2.widthAnchor.constraint(equalToConstant: containerView.frame.size.width ).isActive = true
        sheetView2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -AppLayoutParameter.marginBig).isActive = true
        
        sheetView2.addSubview(nameTextField)
        let nameTextFieldHeight = nameTextField.frame.size.height
        let nameTextFieldWidth = containerView.frame.size.width - AppLayoutParameter.marginBig*2 - AppLayoutParameter.marginSmall - imageView.frame.size.width
        nameTextField.topAnchor.constraint(equalTo: sheetView2.topAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: sheetView2.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: nameTextFieldWidth).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: nameTextFieldHeight).isActive = true
        
        // - - - - - part 2 - image - - - - - //
        
        containerView.addSubview(imageView)
        let imageViewHeight = imageView.frame.size.width
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:AppLayoutParameter.marginSmall).isActive = true
        imageViewLeftConstraint = imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: containerView.frame.size.width/2-imageViewHeight/2)
        imageViewLeftConstraint?.isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        
        // - - - - - part 3 - sheet view 1 - - - - - //

        containerView.addSubview(sheetView1)
        sheetView1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant:AppLayoutParameter.marginSmall).isActive = true
        sheetView1LeftConstraint = sheetView1.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0)
        sheetView1LeftConstraint?.isActive = true
        sheetView1.widthAnchor.constraint(equalToConstant: containerView.frame.size.width ).isActive = true
        sheetView1.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -AppLayoutParameter.marginBig).isActive = true
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureLeft.direction = UISwipeGestureRecognizer.Direction.left
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureRight.direction = UISwipeGestureRecognizer.Direction.right
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipeGestureLeft)
        view.addGestureRecognizer(swipeGestureRight)
    }
    
    // - - - - - - - - - - - - - - button function - - - - - - - - - - - - - - //

    @objc func handleTapImageView(){
        blockAnimateFrom2To1()
    }
    
    @objc func handleBackButton(){
        if isStatus1 == true {
            blockAnimateFrom1To2()
        } else {
            blockAnimateFrom2To1()
        }
    }
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            if isStatus1 == true {
                if isAllowToProgress == true {
                    blockAnimateFrom1To2()
                } else {
                    containerView.animateShakeLess {}
                    print("not allow")
                }
            } else {
                containerView.animateShakeLess {}
            }
        } else if sender.direction == .right {
            if isStatus1 == false {
                blockAnimateFrom2To1()
            } else {
                containerView.animateShakeLess {}
            }
        }
    }
    
    // - - - - - - - - - - - - - - block - - - - - - - - - - - - - - //
    func blockAnimateFrom1To2(){
        isStatus1 = false
        imageViewLeftConstraint?.constant = AppLayoutParameter.marginBig
        sheetView1LeftConstraint?.constant = -containerView.frame.size.width
        sheetView2LeftConstraint?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
            if self.backButton.alpha == 0 {
                self.backButton.alpha = 1
            } else {
                self.backButton.transform = CGAffineTransform.identity
            }
            self.containerView.layoutIfNeeded()
        }, completion: { _ in
            self.nameTextField.becomeFirstResponder()
        })
    }
    
    func blockAnimateFrom2To1(){
        isStatus1 = true
        self.nameTextField.resignFirstResponder()
        imageViewLeftConstraint?.constant = containerView.frame.size.width/2 - imageView.frame.size.width/2
        sheetView1LeftConstraint?.constant = 0
        sheetView2LeftConstraint?.constant = containerView.frame.size.width
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.backButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.containerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    // - - - - - - - - - - - - - - text field - - - - - - - - - - - - - - //

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
