//
//  FridgeTableViewControllerDelegate.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/21.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit

protocol FridgeViewControllerDelegate: class {
    func handleFridgeHeaderExpandClose(header: FridgeHeader)
    func handleFridgeCellReduceButton(cell: UITableViewCell)
    func handleFridgeDidSaveAddPurchase(purchaseAdded: Purchase, isNewPurchase: Bool)
    func handleFridgeDetailDidDeleteOrEditPurchase(product: Product)
}
