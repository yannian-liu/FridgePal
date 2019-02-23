//
//  Setting.swift
//  FridgePal
//
//  Created by Yannian Liu on 20/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class SettingViewController : UIViewController{
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Reset"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.appFontBody
        button.addTarget(self, action: #selector(handleSettingResetButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(resetButton)
        let resetButtonHeight = AppLayoutParameter.buttonLengthSmall
        resetButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant:resetButtonHeight*3).isActive = true
        resetButton.topAnchor.constraint(equalTo: view.topAnchor,constant:200).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: resetButtonHeight).isActive = true
    }
    
    @objc func handleSettingResetButton(){
        print("reset everything, alart needed here")
        
//        Default.shared.setDefaultCategoryAndProduct()
    }
}
