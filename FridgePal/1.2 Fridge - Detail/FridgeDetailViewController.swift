//
//  DetailView.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class FridgeDetailViewController : AppPopViewController, UITableViewDataSource, UITableViewDelegate, FridgeDetailViewControllerDelegate {
    
    
    var product: Product? {
        didSet{
            if let aProduct = product {
                nameLabel.text = aProduct.name
                purchaseArray = fetchPurchaseWith(product: aProduct)
                totalQuantity = aProduct.getTotalQuantityInPurchaseArray(array: purchaseArray)
                tableView.reloadData()
            }
        }
    }

    var indexPath: IndexPath = []
    
    weak var delegate: FridgeViewControllerDelegate?
    
    let fridgeDetailCellId = "fridgeDetailCellId"
    
    var purchaseArray : [Purchase] = []
    
    var totalQuantity = 0 {
        didSet {
            detailLabel.text = "You have \(totalQuantity) in your fridge."
        }
    }
    
    var isEditingPurchases : Bool = false
    
    var foodImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "Untitled"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontTitle1
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have 5 in your fridge."
        return label
    }()
    
    let tableTitleDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBodyMedium
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date."
        label.textAlignment = .center
        return label
    }()
    
    let tableTitleQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBodyMedium
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Qt."
        label.textAlignment = .right
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeDetailEditButton), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FridgeDetailCell.self, forCellReuseIdentifier: self.fridgeDetailCellId)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.appColourGrayMedium
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: AppLayoutParameter.marginBig, bottom: 0, right: AppLayoutParameter.marginBig);
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var addToShoppingListButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthBig, height: AppLayoutParameter.buttonLengthBig)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addShadow()
        button.addTarget(self, action: #selector(handleFridgeDetailAddToShoppingListButton), for: .touchUpInside)
        return button
    }()
    
    lazy var purchaseEditView : FridgeDetailEditPurchaseView = {
        let pev = FridgeDetailEditPurchaseView()
        pev.translatesAutoresizingMaskIntoConstraints = false
        pev.isHidden = true
        pev.delegate = self
        return pev
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        setupView()
    }
    
    
    // - - - - - - - - - - - - - - Setup Style - - - - - - - - - - - - - - //
    
    func setupView () {
        setupDetailContainerView()
        
        self.view.addSubview(purchaseEditView)
        purchaseEditView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        purchaseEditView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        purchaseEditView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        purchaseEditView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        nameLabel.backgroundColor = UIColor.gray
//        detailLabel.backgroundColor = UIColor.lightGray
//        tableTitleQuantityLabel.backgroundColor = UIColor.red
//        tableTitleDateLabel.backgroundColor = UIColor.green
    }
    
    func setupDetailContainerView (){
        // - - - - - Up to Down - - - - - //
        setupPopViewControllerBasic(containerViewHeight: AppLayoutParameter.containerHeightMedium,containerViewLocation: .centre, title: "")

        containerView.addSubview(foodImageView)
        let foodImageViewHeight = AppLayoutParameter.imageHeightSmall
        foodImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        foodImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: foodImageViewHeight).isActive = true
        
        containerView.addSubview(nameLabel)
        let nameLabelHeight = AppLayoutParameter.labelHeightTitle
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabelHeight).isActive = true
        
        containerView.addSubview(detailLabel)
        let detailLabelHeight = AppLayoutParameter.labelHeightContent
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: detailLabelHeight).isActive = true
        
        containerView.addSubview(tableTitleDateLabel)
        let tableTitleDateLabelHeight = AppLayoutParameter.labelHeightContent
        let tableTitleDateLabelWidth = (UIScreen.main.bounds.width - AppLayoutParameter.marginBig*6)/2
        tableTitleDateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        tableTitleDateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginBig*2).isActive = true
        tableTitleDateLabel.widthAnchor.constraint(equalToConstant: tableTitleDateLabelWidth).isActive = true
        tableTitleDateLabel.heightAnchor.constraint(equalToConstant: tableTitleDateLabelHeight).isActive = true

        containerView.addSubview(tableTitleQuantityLabel)
        let tableTitleQuantityLabelHeight = AppLayoutParameter.labelHeightContent
        tableTitleQuantityLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        tableTitleQuantityLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginBig*2.5).isActive = true
        tableTitleQuantityLabel.leftAnchor.constraint(equalTo: tableTitleDateLabel.rightAnchor).isActive = true
        tableTitleQuantityLabel.heightAnchor.constraint(equalToConstant: tableTitleQuantityLabelHeight).isActive = true
        
        containerView.addSubview(editButton)
        let editButtonDiameter = editButton.frame.size.width
        editButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: editButtonDiameter).isActive = true
        editButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: editButtonDiameter).isActive = true
        
        // - - - - - Down to Up - - - - - //
        containerView.addSubview(addToShoppingListButton)
        let addToShoppingListButtonDiameter = addToShoppingListButton.frame.size.width
        addToShoppingListButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addToShoppingListButton.centerYAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(AppLayoutParameter.marginBig + addToShoppingListButtonDiameter/2)).isActive = true
        addToShoppingListButton.widthAnchor.constraint(equalToConstant: addToShoppingListButtonDiameter).isActive = true
        addToShoppingListButton.heightAnchor.constraint(equalToConstant: addToShoppingListButtonDiameter).isActive = true
        
        // - - - - - Flexible - - - - - //
        containerView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: tableTitleDateLabel.bottomAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addToShoppingListButton.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        
    }
    
    // - - - - - - - - - - - - - - TableView - - - - - - - - - - - - - - //

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: fridgeDetailCellId, for: indexPath) as! FridgeDetailCell
        let aPurchase = purchaseArray[indexPath.row]
        aCell.dateLabel.text = aPurchase.date?.dateToString()
        aCell.quantityLabel.text = "× \(aPurchase.quantity)"
        aCell.delegate = self
        return aCell
    }
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    
    @objc func handleFridgeDetailEditButton(){
        if isEditingPurchases == false {
            blockGoEditingWithAnimation()
        } else {
            blockFinishEditingWithAnimation()
        }
    }
    
    func handleFridgeDetailCellDeletePurchaseButton(cell: FridgeDetailCell){
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let aPurchase = purchaseArray[indexPath.row]
        guard let aProduct = aPurchase.product else {return}
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(aPurchase)
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete food from fridge: ", saveErr)
        }
        purchaseArray.remove(at: indexPath.row)
        blockDeleteCellTableViewUpdate(indexPath: indexPath)
        totalQuantity = aProduct.getTotalQuantityInPurchaseArray(array: purchaseArray)
        delegate?.handleFridgeDetailDidDeleteOrEditPurchase(product: aProduct)
    }

    
    func handleFridgeDetailCellEditPurchaseButton(cell: FridgeDetailCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let aPurchase = purchaseArray[indexPath.row]
        purchaseEditView.purchase = aPurchase
        purchaseEditView.indexPath = indexPath
        purchaseEditView.isHidden = false
        purchaseEditView.containerView.animatePulse{}
    }
    
    func handleFridgeDetailCellEditPurchaseDidSave(indexPath: IndexPath) {
        let aPurchase = purchaseArray[indexPath.row]
        guard let aProduct = aPurchase.product else {return}
        var isHasSameDateOne = false
        // if there is a same date, delete this one
        for each in purchaseArray {
            if aPurchase.dateToDate().dateToString() == each.dateToDate().dateToString() {
                if indexPath.row != purchaseArray.index(of: each){
                    isHasSameDateOne = true
                    // delete this
                    let eachQtInt = each.quantityToInt()
                    let aPurchaseQtInt = aPurchase.quantityToInt()
                    let newEachQtInt = eachQtInt+aPurchaseQtInt
                    let newEachQt = Int16(newEachQtInt)
                    let context = CoreDataManager.shared.persistentContainer.viewContext
                    each.quantity = newEachQt
                    context.delete(aPurchase)
                    do {
                        try context.save()
                    } catch let saveErr {
                        print("Failed to delete food from fridge: ", saveErr)
                    }
                    purchaseArray.remove(at: indexPath.row)
                    blockDeleteCellTableViewUpdate(indexPath: indexPath)
                    guard let indexNew = self.purchaseArray.index(of: each) else {return}
                    let indexPathNew = IndexPath(row: indexNew, section: 0)
                    blockReloadCellTableViewUpdate(indexPath: indexPathNew)
                    break
                }
            }
        }
        // sort move
        if isHasSameDateOne == false {
            blockReloadCellTableViewUpdate(indexPath: indexPath)
            purchaseArray.sort { (p1, p2) -> Bool in
                return p1.dateToDate() < p2.dateToDate()
            }
            guard let newIndex = purchaseArray.index(of: aPurchase) else {return}
            tableView.moveRow(at: indexPath, to: IndexPath(row: newIndex, section: 0))
        }
        totalQuantity = aProduct.getTotalQuantityInPurchaseArray(array: purchaseArray)
        delegate?.handleFridgeDetailDidDeleteOrEditPurchase(product: aProduct)
    }
    
    @objc func handleFridgeDetailAddToShoppingListButton(){
        blockFinishEditingWithoutAnimation()
    }
    
    // - - - - - - - - - - - - - - block - - - - - - - - - - - - - - //

    func blockGoEditingWithAnimation(){
        if purchaseArray.count != 0{
            for i in 0...purchaseArray.count-1{
                let aCell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! FridgeDetailCell
                aCell.deleteButton.appearWithAnimationWithAlphaForTwoView(rightView: aCell.editButton, completionBlock: {})
                isEditingPurchases = true
            }
        } else {
            print("purchaseArray is empty")
            isEditingPurchases = false
        }
    }
    
    func blockFinishEditingWithAnimation(){
        if purchaseArray.count != 0 {
            for i in 0...purchaseArray.count-1{
                let aCell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! FridgeDetailCell
                aCell.deleteButton.disappearWithAnimationWithAlphaForTwoView(rightView: aCell.editButton, completionBlock: {})
                isEditingPurchases = false
            }
        } else {
            print("purchase Array is empty")
            isEditingPurchases = false
        }
    }
    
    func blockShowButtonForOneCell(indexPath : IndexPath){
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).deleteButton.isHidden = false
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).editButton.isHidden = false
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).deleteButton.alpha = 1.0
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).editButton.alpha = 1.0
    }
    
    func blockHideButtonForOneCell(indexPath : IndexPath){
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).deleteButton.isHidden = true
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).editButton.isHidden = true
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).deleteButton.alpha = 0.0
        (tableView.cellForRow(at: indexPath) as! FridgeDetailCell).editButton.alpha = 0.0
    }
    
    func blockGoEditingWithoutAnimation(){
        if purchaseArray.count != 0{
            for i in 0...purchaseArray.count-1{
                let indexPath = IndexPath(row: i, section: 0)
                blockShowButtonForOneCell(indexPath: indexPath)
            }
            isEditingPurchases = true
        } else {
            print("purchaseArray is empty")
            isEditingPurchases = false
        }
    }
    
    func blockFinishEditingWithoutAnimation(){
        if purchaseArray.count != 0 {
            for i in 0...purchaseArray.count-1{
                let indexPath = IndexPath(row: i, section: 0)
                blockHideButtonForOneCell(indexPath: indexPath)
            }
            isEditingPurchases = false
        } else {
            print("purchase Array is empty")
            isEditingPurchases = false
        }
    }
    
    // table view cell change, update the table view
    func blockInsertCellTableViewUpdate(indexPath: IndexPath){
        tableView.insertRows(at: [indexPath], with: .none)
        if isEditingPurchases == true {
            blockShowButtonForOneCell(indexPath: indexPath)
        } else {
            blockHideButtonForOneCell(indexPath: indexPath)
        }
//        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
    }
    
    func blockReloadCellTableViewUpdate(indexPath: IndexPath){
        tableView.reloadRows(at: [indexPath], with: .none)
        if isEditingPurchases == true {
            blockShowButtonForOneCell(indexPath: indexPath)
        } else {
            blockHideButtonForOneCell(indexPath: indexPath)
        }
//        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
    }
    
    func blockDeleteCellTableViewUpdate(indexPath: IndexPath){
        blockHideButtonForOneCell(indexPath: indexPath)
//        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // - - - - - - - - - - - - - - basic - - - - - - - - - - - - - - //

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
