//
//  Blur.swift
//  FridgePal
//
//  Created by Yannian Liu on 27/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
