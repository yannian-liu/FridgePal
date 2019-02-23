//
//  CategoryCreateCategoryCollectionCell.swift
//  FridgePal
//
//  Created by Yannian Liu on 22/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryCreateCategoryCollectionCell: UICollectionViewCell{
    var image: UIImage? {
        didSet{
            if let aImage = image {
                imageView.image = aImage.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        iv.frame.size.width = self.frame.size.width/4*3
        iv.frame.size.height = iv.frame.size.width
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = AppLayoutParameter.cornerRadiusMini
        self.tintColor = UIColor.appColour2Medium
        setupView()
    }
    
    func setupView(){
        addSubview(imageView)
        let imageViewHeight = imageView.frame.size.height
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant:imageViewHeight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant:imageViewHeight).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
