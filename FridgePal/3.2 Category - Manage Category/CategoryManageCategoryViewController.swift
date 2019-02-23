//
//  CategoryOrderingView.swift
//  FridgePal
//
//  Created by Yannian Liu on 19/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class CategoryManageCategoryViewController : AppPopViewController, UITableViewDelegate, UITableViewDataSource, CategoryManageCategoryViewControllerDelegate{
    
    
    
    var categoryArray : [Category] = []
    let cellId = "cellId"
    weak var delegate: CategoryViewControllerDelegate?

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryManageCategoryCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.tableFooterView = UIView()
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: AppLayoutParameter.marginSmall, bottom: 0, right: AppLayoutParameter.marginSmall)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = fetchData()
        setupView()
    }
    
    
    // - - - - - - - - - - - - - - set up - - - - - - - - - - - - - - //

    func setupView(){
        setupPopViewControllerBasic(containerViewHeight: AppLayoutParameter.containerHeightMedium, containerViewLocation: .centre, title: "Manage Categories")
        
        containerView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
    }
    
    // - - - - - - - - - - - - - - table view - - - - - - - - - - - - - - //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryManageCategoryCell
        aCell.category = categoryArray[indexPath.row]
        aCell.delegate = self
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeightMini
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeightMini
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.categoryArray[sourceIndexPath.row]
        if sourceIndexPath != destinationIndexPath {
            if sourceIndexPath.row < destinationIndexPath.row {
                // going down
                for i in sourceIndexPath.row+1...destinationIndexPath.row {
                    categoryArray[i].order = Int16(categoryArray[i].order.toInt()-1)
                }
            } else {
                // going up
                for i in destinationIndexPath.row...sourceIndexPath.row-1 {
                    categoryArray[i].order = Int16(categoryArray[i].order.toInt()+1)
                }
            }
            movedObject.order = Int16(destinationIndexPath.row)
            let context = CoreDataManager.shared.persistentContainer.viewContext
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to save a new food: ", saveErr)
            }
            
            categoryArray.remove(at: sourceIndexPath.row)
            categoryArray.insert(movedObject, at: destinationIndexPath.row)
            delegate?.handleCategoryManageCategoryDidMove(category: movedObject)
        }
    }
    
    // - - - - - - - - - - - - - - button handler - - - - - - - - - - - - - - //

    func handleEditCategory(cell: CategoryManageCategoryCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let category = categoryArray[indexPath.row]
        let categoryManageCategoryEditCategoryVC = CategoryMangeCategoryEditCategoryViewController()
        categoryManageCategoryEditCategoryVC.category = category
        categoryManageCategoryEditCategoryVC.delegate2 = self
        self.pushAppPopViewController(viewControllerPushed: categoryManageCategoryEditCategoryVC)
    }
    
    func handleEditDidSave(category: Category) {
        guard let index = categoryArray.index(of: category) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay {}
        delegate?.handleCategoryManageCategoryDidEdit(category: category)
    }
    
    func handleDeleteCategory(cell: CategoryManageCategoryCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let category = categoryArray[indexPath.row]
        self.showAlertWithCancelAndContinue(title: "Delete Category", message: "You will delete all food in this category.", handlerForCancelButton: {
            return
        }) {
            CoreDataManager.shared.deleteCategory(category: category)
            self.categoryArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.handleCategoryManageCategoryDidDelete(category: category)
        }
    }
    
    // - - - - - - - - - - - - - - basic - - - - - - - - - - - - - - //

    func fetchData()->[Category]{
        let sort = NSSortDescriptor(key: #keyPath(Category.order), ascending: true)
        guard let categoryArray = CoreDataManager.shared.fetchCategories(predicate: nil, sortArray: [sort]) else {return []}
        return categoryArray
    }
}
