//
//  FridgeDetailViewDateDetailView.swift
//  FridgePal
//
//  Created by Yannian Liu on 30/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

class FridgeDetailEditPurchaseView: UIView {
    
    weak var delegate: FridgeDetailViewControllerDelegate?
    
    var purchase : Purchase? {
        didSet{
            guard let aDate = purchase?.date else {return}
            datePicker.setDate(aDate, animated: false)
            guard let aQuantity = purchase?.quantity else {return}
            guard let qt = Int("\(aQuantity)") else {return}
            quantity = qt
            quantityLabel.text = "\(quantity)"
        }
    }
    
    var indexPath : IndexPath = []
    
    let containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.setRoundCornerShape()
        containerView.addShadow()
        return containerView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailPurchaseEditViewCloseButton), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontTitle1
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.layer.cornerRadius = AppLayoutParameter.cornerRadius
        //dp.layer.borderWidth = AppLayoutParameter.borderWidth
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.setValue(1, forKey: "alpha")
        dp.setValue(UIColor.appColour2Dark, forKey: "textColor")
        dp.setValue(true, forKey: "highlightsToday")
        return dp
    }()
    
    var quantity : Int = 1 {
        didSet {
            self.quantityLabel.text = "\(quantity)"
        }
    }
    
    let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Quantity: "
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont.appFontTitle2
        label.textAlignment = .center
        return label
    }()
    
    lazy var reduceButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailPurchaseEditViewReduceButton), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailPurchaseEditViewAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthBig, height: AppLayoutParameter.buttonLengthBig)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addShadow()
        button.addTarget(self, action: #selector(handleFridgeDetailPurchaseEditSaveButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        
        self.addSubview(containerView)
        let containerViewHeight = AppLayoutParameter.containerHeightBig
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        setupDetailEditContainerView()
    }
    
    func setupDetailEditContainerView(){
        
        // - - - - - Up to Down - - - - - //

        containerView.addSubview(closeButton)
        let closeButtonDiameter = closeButton.frame.size.width
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonDiameter).isActive = true
        closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonDiameter).isActive = true
        
        containerView.addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightTitle
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        
        // - - - - - Down to Up - - - - - //
        
        containerView.addSubview(saveButton)
        let saveButtonDiameter = saveButton.frame.size.width
        saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(AppLayoutParameter.marginBig + saveButtonDiameter/2)).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        
        containerView.addSubview(quantityTitleLabel)
        let quantityTitleLabelHeight = AppLayoutParameter.labelHeightTitle
        quantityTitleLabel.heightAnchor.constraint(equalToConstant: quantityTitleLabelHeight).isActive = true
        quantityTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        quantityTitleLabel.widthAnchor.constraint(equalToConstant: quantityTitleLabelHeight*3).isActive = true
        quantityTitleLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        
        containerView.addSubview(reduceButton)
        let reduceButtonHeight = AppLayoutParameter.buttonLengthSmall
        reduceButton.heightAnchor.constraint(equalToConstant: reduceButtonHeight).isActive = true
        reduceButton.leftAnchor.constraint(equalTo: quantityTitleLabel.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        reduceButton.widthAnchor.constraint(equalToConstant: reduceButtonHeight).isActive = true
        reduceButton.centerYAnchor.constraint(equalTo: quantityTitleLabel.centerYAnchor).isActive = true
        
        containerView.addSubview(quantityLabel)
        let quantityLabelHeight = AppLayoutParameter.labelHeightTitle
        quantityLabel.heightAnchor.constraint(equalToConstant: quantityLabelHeight).isActive = true
        quantityLabel.leftAnchor.constraint(equalTo: reduceButton.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        quantityLabel.widthAnchor.constraint(equalToConstant: quantityLabelHeight).isActive = true
        quantityLabel.centerYAnchor.constraint(equalTo: reduceButton.centerYAnchor).isActive = true
        
        containerView.addSubview(addButton)
        let addButtonHeight = AppLayoutParameter.buttonLengthSmall
        addButton.heightAnchor.constraint(equalToConstant: addButtonHeight).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: addButtonHeight).isActive = true
        addButton.leftAnchor.constraint(equalTo: quantityLabel.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        addButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor).isActive = true
        // - - - - - Flexible - - - - - //
        
        containerView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        datePicker.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        datePicker.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: quantityTitleLabel.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
    }
    
    @objc func handleFridgeDetailPurchaseEditViewCloseButton(){
        self.isHidden = true
    }
    
    @objc func handleFridgeDetailPurchaseEditSaveButton(){
        guard let purchaseQuantity = purchase?.quantity else {return}
        guard let purchaseQtInt = Int("\(purchaseQuantity)") else {return}
        if datePicker.date != purchase?.date || quantity != purchaseQtInt {
            let dateChangedTo = datePicker.date
            let context = CoreDataManager.shared.persistentContainer.viewContext
            self.purchase?.date = dateChangedTo
            self.purchase?.quantity = Int16(quantity)
            do {
                try context.save()
                self.isHidden = true
                delegate?.handleFridgeDetailCellEditPurchaseDidSave(indexPath: self.indexPath)
            } catch let saveErr {
                print("Failed to save changes of a food: ", saveErr)
            }
        } else {
            self.isHidden = true
        }
    }
    
    @objc func handleFridgeDetailPurchaseEditViewReduceButton(){
        if quantity == 1 {
            quantityLabel.textColor = UIColor.appColour1Medium
            quantityLabel.animateShake {
                self.quantityLabel.textColor = UIColor.appColour2Dark
            }
        } else {
            quantity = quantity-1
        }
    }
    
    @objc func handleFridgeDetailPurchaseEditViewAddButton(){
        quantity = quantity+1
    }
}
