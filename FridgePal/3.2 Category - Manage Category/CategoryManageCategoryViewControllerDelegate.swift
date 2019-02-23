//
//  CategoryManageCategoryViewControllerDelegate.swift
//  FridgePal
//
//  Created by Yannian Liu on 25/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation

protocol CategoryManageCategoryViewControllerDelegate:class  {
    func handleEditCategory(cell: CategoryManageCategoryCell)
    func handleEditDidSave(category: Category)
    func handleDeleteCategory(cell: CategoryManageCategoryCell)
}
