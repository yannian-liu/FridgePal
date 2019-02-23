//
//  FridgeDetailDateEditViewDelegate.swift
//  FridgePal
//
//  Created by Yannian Liu on 30/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
protocol FridgeDetailViewControllerDelegate: class {
    func handleFridgeDetailCellEditPurchaseButton(cell: FridgeDetailCell)
    func handleFridgeDetailCellEditPurchaseDidSave(indexPath: IndexPath)
    func handleFridgeDetailCellDeletePurchaseButton(cell: FridgeDetailCell)
}
