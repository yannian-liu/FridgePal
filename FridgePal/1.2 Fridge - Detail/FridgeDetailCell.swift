//
//  FridgeDetailCell.swift
//  FridgePal
//
//  Created by Yannian Liu on 30/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class FridgeDetailCell: UITableViewCell {
    
    weak var delegate: FridgeDetailViewControllerDelegate?

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailCellDeletePurchaseButton), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0.0
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let quantityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailCellEditPurchaseButton), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0.0
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCell()
        
//        dateLabel.backgroundColor = UIColor.gray
//        quantityLabel.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        // - - - - - Left to Right - - - - - //

        addSubview(deleteButton)
        let deleteButtonHeight = AppLayoutParameter.buttonLengthSmall
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: deleteButtonHeight).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: deleteButtonHeight).isActive = true
        
        addSubview(dateLabel)
        let dateLabelHeight = AppLayoutParameter.labelHeightContent
        let dateLabelWidth = (UIScreen.main.bounds.width - AppLayoutParameter.marginBig*6)/3*2
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginBig*2).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: dateLabelWidth).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: dateLabelHeight).isActive = true

            
        // - - - - - Right to Left - - - - - //

        addSubview(editButton)
        let editButtonHeight = AppLayoutParameter.buttonLengthSmall
        editButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: editButtonHeight).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: editButtonHeight).isActive = true
        
        // - - - - - Flexible - - - - - //
        
        addSubview(quantityLabel)
        let quantityLabelHeight = AppLayoutParameter.labelHeightContent
        quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quantityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginBig*2.5).isActive = true
        quantityLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor).isActive = true
        quantityLabel.heightAnchor.constraint(equalToConstant: quantityLabelHeight).isActive = true
    }
    
    @objc func handleFridgeDetailCellDeletePurchaseButton(){
        delegate?.handleFridgeDetailCellDeletePurchaseButton(cell: self)
    }
    
    @objc func handleFridgeDetailCellEditPurchaseButton(){
        delegate?.handleFridgeDetailCellEditPurchaseButton(cell: self)
    }
}
