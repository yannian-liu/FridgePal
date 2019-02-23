//
//  CategoryMangeCategoryEditCategoryViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 25/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class CategoryMangeCategoryEditCategoryViewController: CategoryCreateCategoryViewController {
    var category: Category? {
        didSet{
            if let aCategory = category {
                if let imageData = aCategory.image {
                    imageInerView.image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate)
                }
                if let aName = aCategory.name {
                    nameTextField.text = aName
                }
                isAllowToProgress = true
            }
        }
    }
    
    weak var delegate2: CategoryManageCategoryViewControllerDelegate?

    override func handleCreateCategoryViewSaveButton(){
        // initialization of our core data
        guard let aName = nameTextField.text else {return}
        guard  let aImage = imageInerView.image else {return}

        if nameTextField.text == "" {
            showAlertWithCancel(title: "Empty Name", message: "You have not entered a name.")
            return
        }
        
        if let aCategory = self.category{
            guard let category = CoreDataManager.shared.saveCategory(category:aCategory, name: aName, image: aImage, order: aCategory.order.toInt(), isDefault: aCategory.isDefault) else {return}
            self.containerView.animatePulse {
                self.navigationController?.popViewController(animated: false)
                self.delegate2?.handleEditDidSave(category: category)
            }
        }
    }
    
}
