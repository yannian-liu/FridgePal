//
//  FoodInFridgeSummary.swift
//  FridgePal
//
//  Created by Yannian Liu on 4/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import CoreData

class FridgeFoodSummary {
    var product: Product
    var totalQuantity : Int
    var earliestPurchaseDate : Date
    var earliestPurchaseQuantity: Int
    
    init(product: Product, totalQuantity: Int, earliestPurchaseDate: Date, earliestPurchaseQuantity: Int) {
        self.product = product
        self.totalQuantity = totalQuantity
        self.earliestPurchaseDate = earliestPurchaseDate
        self.earliestPurchaseQuantity = earliestPurchaseQuantity
    }
    
    func updateFitName(){
        
        guard var purchaseArray = self.product.purchase?.allObjects as? [Purchase] else {return}
        
        if purchaseArray.count == 0 {
            self.totalQuantity = 0
            self.earliestPurchaseDate = Date()
            self.earliestPurchaseQuantity = 0
        } else {
            self.totalQuantity = purchaseArray[0].quantityToInt()
            self.earliestPurchaseDate = purchaseArray[0].dateToDate()
            self.earliestPurchaseQuantity = purchaseArray[0].quantityToInt()
            
            if purchaseArray.count > 1{
                for i in 1...purchaseArray.count-1 {
                    self.totalQuantity = self.totalQuantity + purchaseArray[i].quantityToInt()
                    if purchaseArray[i].dateToDate().compare(self.earliestPurchaseDate) == .orderedAscending {
                        self.earliestPurchaseDate = purchaseArray[i].dateToDate()
                        self.earliestPurchaseQuantity = purchaseArray[i].quantityToInt()
                    }
                }
            }
        }
        
    }
}
