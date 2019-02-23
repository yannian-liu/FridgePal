//
//  FridgeViewController.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class FridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FridgeViewControllerDelegate {
    
    let fridgeCellId = "firdgeCellId"
    let fridgeHeaderId = "fridgeHeaderId"
    
    var categoryArray: [Category] = []
    
    var categorySummaryDict: [Category: ExpandableSectionInFridge] = [:]
    
    //    var fridgeFoodSummary_ExpandavarSvarionArray = [
//        ExpandableSectionInFridge(isExpanded: true, content: [
//            ])
//    ]
    
    let bannerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addPurchaseButton : UIButton = {
        let afb = UIButton()
        afb.frame.size.height = AppLayoutParameter.buttonLengthSmall
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        afb.setImage(tintedImage, for: .normal)
        afb.tintColor = UIColor.appColour1Medium
        afb.setRoundCornerShape()
        afb.translatesAutoresizingMaskIntoConstraints = false
        afb.addTarget(self, action: #selector(handleFridgeAddPurchaseButton), for: .touchUpInside)
        return afb
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FridgeCell.self, forCellReuseIdentifier: fridgeCellId)
        tableView.register(FridgeHeader.self, forHeaderFooterViewReuseIdentifier: fridgeHeaderId)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: AppLayoutParameter.marginBig, bottom: 0, right: AppLayoutParameter.marginBig)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.appColourGrayMedium
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPurchaseAndMakeDict()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // - - - - - - - - - - - - - - Setup Style - - - - - - - - - - - - - - //
    
    func setupView(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(bannerView)
        bannerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: AppLayoutParameter.bannerHeight).isActive = true
        setupBannerView()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-100).isActive = true
    }
    
    func setupBannerView(){
        bannerView.addSubview(addPurchaseButton)
        let addFoodButtonHeight = addPurchaseButton.frame.size.height
        addPurchaseButton.heightAnchor.constraint(equalToConstant: addFoodButtonHeight).isActive = true
        addPurchaseButton.widthAnchor.constraint(equalToConstant: addFoodButtonHeight).isActive = true
        addPurchaseButton.rightAnchor.constraint(equalTo: bannerView.rightAnchor, constant: -AppLayoutParameter.marginMedium).isActive = true
        addPurchaseButton.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
    }
    
    // - - - - - - - - - - - - - - Header - - - - - - - - - - - - - - //
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: fridgeHeaderId) as! FridgeHeader
        aHeader.nameLabel.text = categoryArray[section].name
        aHeader.delegate = self
        aHeader.tag = section
        return aHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppLayoutParameter.headerHeight
    }
    // - - - - - - - - - - - - - - Footer - - - - - - - - - - - - - - //
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "no food in fridge"
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.numberOfSections == 0 ? 150 : 0
    }
    
    // - - - - - - - - - - - - - - Cell - - - - - - - - - - - - - - //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let aCategory = categoryArray[section]
        guard let aExp = categorySummaryDict[aCategory] else {return 0 }
        if !aExp.isExpanded{
            return 0
        }
        return aExp.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: fridgeCellId, for: indexPath) as! FridgeCell
        aCell.delegate = self
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else { return aCell}
        let aSummary = aExp.content[indexPath.row]
        let product = aSummary.product
        let totalQuantity = aSummary.totalQuantity
        let earliestPurchaseDate = aSummary.earliestPurchaseDate
        let earliestPurchaseQuantity = aSummary.earliestPurchaseQuantity
        aCell.nameLabel.text = product.name
        if let imageData = product.image {
            aCell.foodImageView.image = UIImage(data: imageData)
        }
        aCell.totalQuantityLabel.text = "×\(totalQuantity)"
        aCell.earliestPurchasedDateLabel.text = earliestPurchaseDate.dateToString()
        aCell.earliestPurchasedQuantityLabel.text = "×\(earliestPurchaseQuantity)"
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else { return }
        let aSummary = aExp.content[indexPath.row]
        let fridgeDetailViewController = FridgeDetailViewController()
        fridgeDetailViewController.product = aSummary.product
        fridgeDetailViewController.delegate = self
        self.pushAppPopViewController(viewControllerPushed: fridgeDetailViewController)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            let addToSLAction = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                // function executive
                
                completionHandler(true)
            })
            addToSLAction.image = UIImage(named: "plus")
            addToSLAction.backgroundColor = UIColor.appColour2Medium
            let configuration = UISwipeActionsConfiguration(actions: [addToSLAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: title, handler: { (action, view, completionHandler) in
            self.blockDeleteFoodFromFridgeForSwipe(indexPath: indexPath)
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "plus")
        deleteAction.backgroundColor = UIColor.appColour1Medium
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    @available(iOS, deprecated : 11.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete"){ (_, indexPath) in
            self.blockDeleteFoodFromFridgeForSwipe(indexPath: indexPath)
        }
        deleteAction.backgroundColor = UIColor.appColour1Medium
        return [deleteAction]
    }
    
    func blockDeleteFoodFromFridgeForSwipe(indexPath: IndexPath){
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else { return }
        let aSummary = aExp.content[indexPath.row]
        let aProduct = aSummary.product
        aExp.content.remove(at: indexPath.row)
        blockDeleteRowTableViewUpdate(indexPath: indexPath)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Purchase>(entityName: "Purchase")
        let predicate = NSPredicate(format: "product == %@", aProduct)
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
        } catch let delErr {
            print("Failed to delete food from fridge: ", delErr)
        }
        if aExp.content.count == 0 {
            // delete category
            categorySummaryDict.removeValue(forKey: aCategory)
            makeCategoryArray(dict: categorySummaryDict)
//            tableView.deleteSections([indexPath.section], with: .none)
            tableView.reloadData()
        }
    }
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    @objc func handleFridgeAddPurchaseButton() {
        let fridgeAddPurchaseViewController = FridgeAddPurchaseViewController()
        fridgeAddPurchaseViewController.delegate = self
        self.pushAppPopTwoViewController(viewControllerPushed: fridgeAddPurchaseViewController)
    }
    
    func handleFridgeDidSaveAddPurchase(purchaseAdded: Purchase, isNewPurchase: Bool){
        guard let aProduct = purchaseAdded.product else {return}
        if isNewPurchase == true {
            // change VC data
            print("merge new purchase into summaries")
            purchaseAdded.mergeIntoFridgeCategorySummaryDict(categorySummaryDict: &categorySummaryDict)
            makeCategoryArray(dict: categorySummaryDict)
            // update table
            guard let indexPath = aProduct.getIndexPathInCategorySummaryDict(categorySummaryDict: categorySummaryDict, categoryArray: categoryArray) else {return}
            switch purchaseAdded.mergeStyle {
            case .insertCategoryAndSummary?:
                blockInsertSectionTableViewUpdate(indexPath: indexPath)
            case .insertSummary?:
                blockInsertRowTableViewUpdate(indexPath: indexPath)
            case .update?:
                blockReloadRowTableViewUpdate(indexPath: indexPath)
            default:
                print("there is no Purchase mergestyle")
            }
        } else {
            print("no need to merge, just update")
            guard let indexPath = aProduct.getIndexPathInCategorySummaryDict(categorySummaryDict: categorySummaryDict, categoryArray: categoryArray) else {return}
            guard let aCategory = aProduct.category else {return}
            guard let aExp = categorySummaryDict[aCategory] else {return}
            aExp.content[indexPath.row].updateFitName()
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            blockReloadRowTableViewUpdate(indexPath: indexPath)
        }
    }
    
    func handleFridgeHeaderExpandClose (header: FridgeHeader) {
        let sectionSelected = header.tag
        let aCategory = categoryArray[sectionSelected]
        guard let aExp = categorySummaryDict[aCategory] else {return}
        var aIndexPathArray = [IndexPath]()
        for row in aExp.content.indices {
            let aIndexPath = IndexPath(row: row, section: sectionSelected)
            aIndexPathArray.append(aIndexPath)
        }
        
        let isExpanded = aExp.isExpanded
        aExp.isExpanded = !isExpanded
        
        header.expandCloseButton.setTitle(isExpanded ? "open" : "close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: aIndexPathArray, with: .fade)
        } else {
            tableView.insertRows(at: aIndexPathArray, with: .fade)
        }
    }
    
    func handleFridgeCellReduceButton(cell: UITableViewCell) {

    }
    
    func handleFridgeDetailDidDeleteOrEditPurchase(product: Product){
        guard let indexPath = product.getIndexPathInCategorySummaryDict(categorySummaryDict: categorySummaryDict, categoryArray: categoryArray) else {return}
        guard let aCategory = product.category else {return}
        guard let aExp = categorySummaryDict[aCategory] else {return}
        aExp.content[indexPath.row].updateFitName()
        if aExp.content[indexPath.row].totalQuantity == 0 {
            aExp.content.remove(at: indexPath.row)
            blockDeleteRowTableViewUpdate(indexPath: indexPath)
            if aExp.content.count == 0 {
                categorySummaryDict.removeValue(forKey: aCategory)
                makeCategoryArray(dict: categorySummaryDict)
//                tableView.deleteSections([indexPath.section], with: .none)
                tableView.reloadData()
            }
        } else {
            blockReloadRowTableViewUpdate(indexPath: indexPath)
        }
    }
    
    // - - - - - - - - - - - - - - block - - - - - - - - - - - - - - //

    func blockInsertSectionTableViewUpdate(indexPath: IndexPath){
        tableView.insertSections([indexPath.section], with: .none)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        // do we need to insert rows in this section?????????
    }
    
    func blockInsertRowTableViewUpdate(indexPath: IndexPath){
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else {return}
        if aExp.isExpanded == true {
            tableView.insertRows(at: [indexPath], with: .none)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            let headerAdded = tableView.headerView(forSection: indexPath.section) as! FridgeHeader
            handleFridgeHeaderExpandClose(header: headerAdded)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
    }
    
    func blockReloadRowTableViewUpdate(indexPath: IndexPath){
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else {return}
        if aExp.isExpanded == true {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            let headerAdded = tableView.headerView(forSection: indexPath.section) as! FridgeHeader
            handleFridgeHeaderExpandClose(header: headerAdded)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
    }
    
    func blockDeleteRowTableViewUpdate(indexPath: IndexPath){
        let aCategory = categoryArray[indexPath.section]
        guard let aExp = categorySummaryDict[aCategory] else {return}
        if aExp.isExpanded == true {
            tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            let headerAdded = tableView.headerView(forSection: indexPath.section) as! FridgeHeader
            handleFridgeHeaderExpandClose(header: headerAdded)
        }
        // check category state, delete if needed.
    }
    
    // - - - - - - - - - - - - - - data basic - - - - - - - - - - - - - - //
    
    func fetchPurchaseAndMakeDict(){
        // fetch
        guard let allPurchaseArray = CoreDataManager.shared.fetchPurchases(predicate: nil, sortArray: nil) else {return}
        // Make Dict
        var dict: [Category: ExpandableSectionInFridge] = [:]
        for each in allPurchaseArray {
            each.mergeIntoFridgeCategorySummaryDict(categorySummaryDict: &dict)
        }
        self.categorySummaryDict = dict
        // Make Array
        makeCategoryArray(dict: dict)
    }
    func makeCategoryArray(dict: [Category:ExpandableSectionInFridge]){
        self.categoryArray = dict.keys.sorted(by: { (c1, c2) -> Bool in
            c1.order < c2.order
        })
    }
}
