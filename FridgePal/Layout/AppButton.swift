//
//  AppButton.swift
//  FridgePal
//
//  Created by Yannian Liu on 19/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
extension UIButton{
    func setTemplateImage(imageName: String, tintColour: UIColor){
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = tintColour
    }
}
