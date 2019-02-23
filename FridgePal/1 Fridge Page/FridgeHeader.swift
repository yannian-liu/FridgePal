//
//  FridgeHeader.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit


class FridgeHeader: UITableViewHeaderFooterView{
    
    weak var delegate: FridgeViewControllerDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "init header"
        label.font = UIFont.appFontTitle1
        label.textColor = UIColor.appColour2Medium
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var expandCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.black, for:.normal)
        button.backgroundColor = UIColor.appColour1Medium
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFridgeHeaderExpandCloseButton), for: .touchUpInside)
        return button
        
    }()
    
    func setupHeader() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        self.backgroundView = backgroundView
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(expandCloseButton)
        expandCloseButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        expandCloseButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        expandCloseButton.widthAnchor.constraint(equalToConstant: AppLayoutParameter.buttonLengthBig).isActive = true
        expandCloseButton.heightAnchor.constraint(equalToConstant: AppLayoutParameter.buttonLengthSmall).isActive = true

    }
    
    @objc func handleFridgeHeaderExpandCloseButton(button: UIButton){
        delegate?.handleFridgeHeaderExpandClose(header: self)
    }
}
