//
//  FridgeCell.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//
import UIKit


class FridgeCell: UITableViewCell {
    
    weak var delegate: FridgeViewControllerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Untitled"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size.width = AppLayoutParameter.cellHeight*2/3
        imageView.setRoundShape()
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "init lable of nameLabel"
        label.font = UIFont.appFontTitle3
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.green
        return label
    }()
    
    let totalQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "none"
        label.font = UIFont.appFontTitle3
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let earliestPurchasedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "init lable of earliestPurchasedDate"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.gray
        return label
    }()
    
    let earliestPurchasedQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "none"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.gray
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.appColour2Dark
        return label
    }()
    
    lazy var reduceButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:20, height:20)
        let origImage = UIImage(named: "Untitled")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour2Medium
        button.addTarget(self, action: #selector(handleFridgeCellReduceButton), for: .touchUpInside)
        return button
    }()
    
    func setupCell() {
        self.selectionStyle = .none
        accessoryView = reduceButton
        
        addSubview(foodImageView)
        let foodImageViewHeight = foodImageView.frame.size.width
        foodImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        foodImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        
        addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.cellHeight*3/10
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:AppLayoutParameter.cellHeight*1/10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        
        addSubview(totalQuantityLabel)
        let totalQuantityLabelHeight = AppLayoutParameter.cellHeight*3/10
        totalQuantityLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        totalQuantityLabel.widthAnchor.constraint(equalToConstant: totalQuantityLabelHeight*3).isActive = true
        totalQuantityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        totalQuantityLabel.heightAnchor.constraint(equalToConstant: totalQuantityLabelHeight).isActive = true
        
        addSubview(earliestPurchasedDateLabel)
        let earliestPurchasedDateLabelHeight = AppLayoutParameter.cellHeight*3/10
        earliestPurchasedDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        earliestPurchasedDateLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        earliestPurchasedDateLabel.widthAnchor.constraint(equalToConstant: earliestPurchasedDateLabelHeight*6).isActive = true
        earliestPurchasedDateLabel.heightAnchor.constraint(equalToConstant: earliestPurchasedDateLabelHeight).isActive = true

        addSubview(earliestPurchasedQuantityLabel)
        let earliestPurchasedQuantityLabelHeight = AppLayoutParameter.cellHeight*3/10
        earliestPurchasedQuantityLabel.centerYAnchor.constraint(equalTo: earliestPurchasedDateLabel.centerYAnchor).isActive = true
        earliestPurchasedQuantityLabel.leftAnchor.constraint(equalTo: earliestPurchasedDateLabel.rightAnchor).isActive = true
        earliestPurchasedQuantityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        earliestPurchasedQuantityLabel.heightAnchor.constraint(equalToConstant: earliestPurchasedQuantityLabelHeight).isActive = true

        addSubview(statusLabel)
        let statusLabelHeight = AppLayoutParameter.cellHeight*2/10
        statusLabel.topAnchor.constraint(equalTo: earliestPurchasedDateLabel.bottomAnchor).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: statusLabelHeight).isActive = true
    }
    
    @objc private func handleFridgeCellReduceButton(){
        delegate?.handleFridgeCellReduceButton(cell: self)
    }
}
    

