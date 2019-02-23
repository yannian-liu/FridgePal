//
//  FridgeAddPurchaseCell.swift
//  FridgePal
//
//  Created by Yannian Liu on 18/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class FridgeAddPurchaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let containerView: UIView = {
        let cv = UIView()
        cv.frame.size = CGSize(width: AppLayoutParameter.cellHeightSmall-AppLayoutParameter.marginSmall, height: AppLayoutParameter.cellHeightSmall-AppLayoutParameter.marginSmall)
        cv.setRoundCornerShape()
        cv.backgroundColor = UIColor.white
        cv.layer.borderColor = UIColor.appColour2Medium.cgColor
        cv.layer.borderWidth = AppLayoutParameter.borderWidth
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var foodImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Untitled"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size.width = self.containerView.frame.height/3*2
        imageView.setRoundShape()
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "init lable of nameLabel"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.green
        return label
    }()
    
    func setupCell(){
        addSubview(containerView)
        let containerViewHeight = containerView.frame.size.height
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor ).isActive = true
        setupContainerView()
    }
    
    func setupContainerView(){
        containerView.addSubview(foodImageView)
        let foodImageViewDiametre = foodImageView.frame.size.width
        foodImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        foodImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:AppLayoutParameter.marginSmall).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: foodImageViewDiametre).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: foodImageViewDiametre).isActive = true
        
        containerView.addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightContent
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant:AppLayoutParameter.marginSmall).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
    }
}
