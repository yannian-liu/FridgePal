//
//  AppButtonStyle.swift
//  FridgePal
//
//  Created by Yannian Liu on 27/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRoundShape(){
        self.layer.cornerRadius = 0.5 * self.frame.size.width
        //self.clipsToBounds = true
    }
    
    func setRoundCornerShape (){
        self.layer.cornerRadius = AppLayoutParameter.cornerRadius
    }
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        let border = CAShapeLayer()
        border.strokeColor = strokeColor.cgColor
        border.lineDashPattern = [4, 9]
        border.lineWidth = lineWidth
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.addSublayer(border)
    }
    
    func underlined(color: UIColor, width: CGFloat){
        let border = CALayer()
        let width: CGFloat = width
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
  
}

class DashedBorderView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 4
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var dashPaintedSize: Int = 2
    @IBInspectable var dashUnpaintedSize: Int = 2
    @IBInspectable var lineWidth: CGFloat = 1.0

    let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(borderColor: UIColor, dashPaintedSize: Int,dashUnpaintedSize: Int, lineWidth: CGFloat ) {
        self.init()
        self.borderColor = borderColor
        self.dashPaintedSize = dashPaintedSize
        self.dashUnpaintedSize = dashUnpaintedSize
        self.lineWidth = lineWidth
        commonInit()
    }
    
    private func commonInit() {
        //custom initialization
        self.layer.addSublayer(dashedBorder)
        applyDashBorder()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        applyDashBorder()
    }
    
    func applyDashBorder() {
        dashedBorder.strokeColor = borderColor.cgColor
        dashedBorder.lineDashPattern = [NSNumber(value: dashPaintedSize), NSNumber(value: dashUnpaintedSize)]
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = cornerRadius
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        dashedBorder.frame = self.bounds
        dashedBorder.lineWidth = lineWidth
    }
}
