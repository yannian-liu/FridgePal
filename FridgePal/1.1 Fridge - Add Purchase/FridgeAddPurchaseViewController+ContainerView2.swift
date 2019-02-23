//
//  FridgeAddPurchaseView+ContainerView2.swift
//  FridgePal
//
//  Created by Yannian Liu on 9/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

extension FridgeAddPurchaseViewController {
    
    // - - - - - - - - - - - - - - Set up - - - - - - - - - - - - - - //

    func setupAddFoodContainerView2(){
        
        // - - - - - Up to Down - - - - - //
        
        containerView2.addSubview(foodImageView)
        let foodImageViewHeight = AppLayoutParameter.imageHeightSmall
        foodImageView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        foodImageView.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        
        containerView2.addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightTitle
        nameLabel.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: closeButton2.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        
        containerView2.addSubview(detailLabel)
        let detailLabelHeight = AppLayoutParameter.labelHeightContent
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: containerView2.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: detailLabelHeight).isActive = true
        
        containerView2.addSubview(purchaseDateTitileLabel)
        purchaseDateTitileLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        purchaseDateTitileLabel.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        purchaseDateTitileLabel.rightAnchor.constraint(equalTo: containerView2.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        purchaseDateTitileLabel.heightAnchor.constraint(equalToConstant: AppLayoutParameter.labelHeightContent).isActive = true
        
        // - - - - - Down to Up - - - - - //
        
        containerView2.addSubview(saveButton)
        let saveButtonDiameter = saveButton.frame.size.width
        saveButton.centerXAnchor.constraint(equalTo: containerView2.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: containerView2.bottomAnchor, constant: -(AppLayoutParameter.marginBig + saveButtonDiameter/2)).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        
        containerView2.addSubview(quantityTitleLabel)
        let quantityTitleLabelHeight = AppLayoutParameter.labelHeightTitle
        quantityTitleLabel.heightAnchor.constraint(equalToConstant: quantityTitleLabelHeight).isActive = true
        quantityTitleLabel.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        quantityTitleLabel.widthAnchor.constraint(equalToConstant: quantityTitleLabelHeight*3).isActive = true
        quantityTitleLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        
        containerView2.addSubview(reduceButton)
        let reduceButtonHeight = AppLayoutParameter.buttonLengthSmall
        reduceButton.heightAnchor.constraint(equalToConstant: reduceButtonHeight).isActive = true
        reduceButton.leftAnchor.constraint(equalTo: quantityTitleLabel.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        reduceButton.widthAnchor.constraint(equalToConstant: reduceButtonHeight).isActive = true
        reduceButton.centerYAnchor.constraint(equalTo: quantityTitleLabel.centerYAnchor).isActive = true
        
        containerView2.addSubview(quantityLabel)
        let quantityLabelHeight = AppLayoutParameter.labelHeightTitle
        quantityLabel.heightAnchor.constraint(equalToConstant: quantityLabelHeight).isActive = true
        quantityLabel.leftAnchor.constraint(equalTo: reduceButton.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        quantityLabel.widthAnchor.constraint(equalToConstant: quantityLabelHeight).isActive = true
        quantityLabel.centerYAnchor.constraint(equalTo: reduceButton.centerYAnchor).isActive = true
        
        containerView2.addSubview(addButton)
        let addButtonHeight = AppLayoutParameter.buttonLengthSmall
        addButton.heightAnchor.constraint(equalToConstant: addButtonHeight).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: addButtonHeight).isActive = true
        addButton.leftAnchor.constraint(equalTo: quantityLabel.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        addButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor).isActive = true
        
        // - - - - - Flexible - - - - - //
        
        containerView2.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: purchaseDateTitileLabel.bottomAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        datePicker.leftAnchor.constraint(equalTo: containerView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        datePicker.rightAnchor.constraint(equalTo: containerView2.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: quantityTitleLabel.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
    }
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    
    @objc func handleFridgeAddPurchaseViewSaveButton(){
        let aDate = datePicker.date
        var isExist = false
        for each in purchaseArray {
            if each.dateToDate().dateToString() == aDate.dateToString() {
                print("add onto old purchase")
                // add onto old purchase
                var purchaseQt = each.quantityToInt()
                purchaseQt = purchaseQt + quantity
                each.quantity = Int16(purchaseQt)
                let context = CoreDataManager.shared.persistentContainer.viewContext
                do {
                    try context.save()
                    handleCloseButton()
                    self.delegate?.handleFridgeDidSaveAddPurchase(purchaseAdded: each, isNewPurchase: false)
                } catch let saveErr {
                    print("Failed to save a new food: ", saveErr)
                }
                isExist = true
                break
            }
        }
        if isExist == false {
            // add new purchase
            print("add new purchase")
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let aNewPurchase = NSEntityDescription.insertNewObject(forEntityName: "Purchase", into: context) as! Purchase
            aNewPurchase.product = self.product
            aNewPurchase.date = aDate
            aNewPurchase.quantity = Int16(quantity)
            do {
                try context.save()
                handleCloseButton()
                self.delegate?.handleFridgeDidSaveAddPurchase(purchaseAdded: aNewPurchase, isNewPurchase: true)
            } catch let saveErr {
                print("Failed to save a new food: ", saveErr)
            }
            purchaseArray = fetchPurchaseWith(product: self.product)
        }
    }
    
    @objc func handleFridgeAddPurchaseViewReduceButton(){
        if quantity == 1 {
            quantityLabel.textColor = UIColor.appColour1Medium
            quantityLabel.animateShake {
                self.quantityLabel.textColor = UIColor.appColour2Dark
            }
        } else {
            quantity = quantity-1
        }
    }
    
    @objc func handleFridgeAddPurchaseViewAddButton(){
        quantity = quantity+1
    }
    
    // - - - - - - - - - - - - - - base - - - - - - - - - - - - - - //
    
    func fetchPurchaseWith(product: Product?) -> [Purchase] {
        guard let aProduct = product else {return []}
        guard let array = aProduct.purchase?.allObjects as? [Purchase] else {return []}
        let purchaseArray = array.sorted(by: { (pur1, pur2) -> Bool in
            if let date1 = pur1.date, let date2 = pur2.date {
                return date1 < date2
            } else {
                return false
            }
        })
        return purchaseArray
    }
}
