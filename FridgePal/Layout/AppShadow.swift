//
//  AppShadow.swift
//  FridgePal
//
//  Created by Yannian Liu on 29/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(){
        self.layer.shadowColor = UIColor.appColourGrayDark.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func addShadowHigh(){
        self.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
    }
}
