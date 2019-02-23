//
//  CategoryManageCategoryCell.swift
//  FridgePal
//
//  Created by Yannian Liu on 25/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryManageCategoryCell: UITableViewCell {
    
    var category: Category? {
        didSet{
            if let aCategory = category{
                if let imageData = aCategory.image {
                    categoryImageView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
                }
                if let aName = aCategory.name {
                    nameLabel.text = aName
                }
                editButton.isHidden = aCategory.isDefault
                deleteButton.isHidden = aCategory.isDefault
            }
        }
    }
    
    var indexPath : IndexPath? = nil
    
    weak var delegate: CategoryManageCategoryViewControllerDelegate?
    
    var categoryImageView : UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width: AppLayoutParameter.cellHeightSmall/2, height: AppLayoutParameter.cellHeightSmall/2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.appColour2Medium
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.appFontBody
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white

        addSubview(categoryImageView)
        let imageViewHeight = AppLayoutParameter.cellHeightSmall/2
        categoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        categoryImageView.widthAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        categoryImageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        
        addSubview(editButton)
        let editButtonHeight = editButton.frame.size.height
        editButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -AppLayoutParameter.marginBig*1.5).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: editButtonHeight).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: editButtonHeight).isActive = true
        
        addSubview(deleteButton)
        let deleteButtonHeight = deleteButton.frame.size.height
        deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -AppLayoutParameter.marginSmall/2).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: deleteButtonHeight).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: deleteButtonHeight).isActive = true
        
        addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightContent
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: categoryImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: deleteButton.leftAnchor,constant: -AppLayoutParameter.marginSmall).isActive = true
        
    }
    
    @objc func handleEditButton(){
        delegate?.handleEditCategory(cell: self)
    }
    
    @objc func handleDeleteButton(){
        delegate?.handleDeleteCategory(cell: self)
    }
}
