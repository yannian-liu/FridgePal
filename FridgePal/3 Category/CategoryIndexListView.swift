//
//  CategoryIndexListView.swift
//  FridgePal
//
//  Created by Yannian Liu on 23/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryIndexListView: UIView {
    
    var categoryArray :[Category] = []
    var categoryCount : Int = 0
    
    var viewHeightMax: CGFloat = 0.0
    var viewWidthMax: CGFloat = AppLayoutParameter.indexListWidthMax
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var padding: CGFloat = 0
    var iconWidth: CGFloat = 0
    
    var imageViewArray: [UIImageView] = []
    var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(categoryArray: [Category], viewHeightMax: CGFloat){
        self.init()
        self.categoryArray = categoryArray
        self.viewHeightMax = viewHeightMax
        categoryCount = self.categoryArray.count
        setupView(viewHeightMax: viewHeightMax)
        setupSubview()
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(viewHeightMax: CGFloat){
        backgroundColor = UIColor.white

        let paddingMax = viewWidthMax/6
        let iconWidthMax = paddingMax*4
        if iconWidthMax * CGFloat(categoryCount) + paddingMax * CGFloat(categoryCount+1) < viewHeightMax {
            // subview could be max
            padding = paddingMax
            iconWidth = iconWidthMax
            viewHeight = iconWidth * CGFloat(categoryCount) + padding * CGFloat(categoryCount+1)
            viewWidth = viewWidthMax
        } else {
            padding = viewHeightMax/CGFloat(categoryCount+1 + categoryCount*4)
            iconWidth = padding*4
            viewHeight = viewHeightMax
            viewWidth = padding*2+iconWidth
        }
        self.frame.size = CGSize(width: viewWidth, height: viewHeight)
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.addShadowHigh()
    }
    
    func setupSubview(){
        
        imageViewArray = categoryArray.map { (category) -> UIImageView in
            if let imageData = category.image {
                let imageView = UIImageView()
                imageView.tintColor = UIColor.appColour2Medium
                imageView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
                imageView.frame.size = CGSize(width: iconWidth, height: iconWidth)
                imageView.setRoundShape()
                imageView.clipsToBounds = true
                imageView.addShadowHigh()
                imageView.isUserInteractionEnabled = true
                return imageView
            } else {
                return UIImageView()
            }
        }

        stackView = UIStackView(arrangedSubviews: imageViewArray)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        let stackViewWidth = padding*2 + iconWidth
        stackView.frame = CGRect(x: self.frame.size.width-stackViewWidth, y: 0, width: stackViewWidth, height: self.frame.size.height)
        stackView.isUserInteractionEnabled = true
        self.addSubview(stackView)

    }
    
    func reset(categoryArray: [Category]){
        stackView.removeFromSuperview()
        self.categoryArray = categoryArray
        categoryCount = self.categoryArray.count
        setupView(viewHeightMax: self.viewHeightMax)
        setupSubview()
    }
    
}
