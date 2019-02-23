//
//  CategoryHeader.swift
//  FridgePal
//
//  Created by Yannian Liu on 12/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryHeader: UITableViewHeaderFooterView {
    weak var delegate: CategoryViewControllerDelegate?
    
    var category : Category? {
        didSet {
            if let aCategory = category {
                if let aName = aCategory.name {
                    nameLabel.text = "\(aName) \(aCategory.order.toInt())"
                }
                if let imageData = aCategory.image {
                    categoryImageView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
//                    categoryImageView.image = UIImage(named: "star")
                }
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.appColour2Medium
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "init header"
        label.font = UIFont.appFontBodyMedium
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupHeader() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        self.backgroundView = backgroundView
        
        addSubview(categoryImageView)
        let categoryImageViewHeight = AppLayoutParameter.buttonLengthSmall
        categoryImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        categoryImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        categoryImageView.widthAnchor.constraint(equalToConstant: categoryImageViewHeight).isActive = true
        categoryImageView.heightAnchor.constraint(equalToConstant: categoryImageViewHeight).isActive = true
        
        addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightContent
        let nameLabelWidth = UIScreen.main.bounds.size.width - AppLayoutParameter.marginSmall*3 - categoryImageViewHeight
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginSmall*2+AppLayoutParameter.buttonLengthSmall).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: nameLabelWidth).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
    }
}
