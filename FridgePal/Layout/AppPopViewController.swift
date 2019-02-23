//
//  AppPopViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 11/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class AppPopViewController: UIViewController {
    
    lazy var containerView1OriginalCentre = self.view.center
    lazy var containerView2OriginalCentre = CGPoint(x: self.view.center.x*3, y:self.view.center.y)
    
    // baseView is for shadow, containerView is for clipsToBounds
    lazy var baseView : UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: UIScreen.main.bounds.width - AppLayoutParameter.marginBig*2, height: AppLayoutParameter.containerHeightMedium)
        view.setRoundCornerShape()
        view.addShadow()
        return view
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.white
        containerView.frame.size.width = baseView.frame.size.width
        containerView.setRoundCornerShape()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var closeButton: UIButton = {
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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Default"
        label.font = UIFont.appFontTitle3
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func handleCloseButton(){
        baseView.animatePulse {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func setupPopViewControllerBasic(containerViewHeight: CGFloat, containerViewLocation: ContainerViewLocation, title: String){
        self.view.addSubview(baseView)
        
        switch containerViewLocation {
        case .top:
            baseView.frame.size = CGSize(width: UIScreen.main.bounds.width - AppLayoutParameter.marginBig*2, height: containerViewHeight)
            baseView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
        case .centre:
            baseView.frame.size = CGSize(width: UIScreen.main.bounds.width - AppLayoutParameter.marginBig*2, height: containerViewHeight)
            baseView.center = self.containerView1OriginalCentre
        }
        
        
        baseView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: baseView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo:baseView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        let titleLabelHeight = AppLayoutParameter.labelHeightTitle
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant:AppLayoutParameter.marginBig).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: containerView.frame.size.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true
        titleLabel.text = title
        
        containerView.addSubview(closeButton)
        let closeButtonDiameter = closeButton.frame.size.width
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonDiameter).isActive = true
        closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonDiameter).isActive = true
        

    }
}
