//
//  CategoryCell.swift
//  FridgePal
//
//  Created by Yannian Liu on 23/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    var product: Product? {
        didSet{
            if let aProduct = product {
                if let aName = aProduct.name {
                    nameLabel.text = aName
                }
                if let aImageData = aProduct.image {
                    productImageView.image = UIImage(data:aImageData)
                }
                isDefault = aProduct.isDefault
                isStarred = aProduct.isStarred
            }
        }
    }
    
    var isDefault : Bool? = nil
    var isStarred : Bool? = nil
    
    var productImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.width = AppLayoutParameter.imageHeightSmall
        view.frame.size.height = AppLayoutParameter.imageHeightSmall
        view.tintColor = UIColor.appColour2Medium
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFontBodyMedium
        return label
    }()
    
    lazy var starButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.gray
        button.frame.size.width = AppLayoutParameter.buttonLengthSmall
        button.setTemplateImage(imageName: "star", tintColour: UIColor.appColour2Medium)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .gray
        setupCell()
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        
        self.addSubview(productImageView)
        let productImageViewWidth = productImageView.frame.size.width
        productImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        productImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: productImageViewWidth).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: productImageViewWidth).isActive = true
        
        let buttonWidth = starButton.frame.size.width
        self.addSubview(starButton)
        starButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        starButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: starButton.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: AppLayoutParameter.labelHeightContent).isActive = true
    }
}

