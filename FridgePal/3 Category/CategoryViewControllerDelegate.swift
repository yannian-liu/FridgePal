//
//  File.swift
//  FridgePal
//
//  Created by Yannian Liu on 12/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit

protocol CategoryViewControllerDelegate: class {
    func handleCategoryCreateCategoryDidSave(category: Category)
    func handleCategoryCreateProductDidSave(product: Product)
    func handleCategoryManageCategoryDidDelete(category: Category)
    func handleCategoryManageCategoryDidEdit(category: Category)
    func handleCategoryManageCategoryDidMove(category: Category)
}
