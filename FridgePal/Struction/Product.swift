//
//  Product.swift
//  FridgePal
//
//  Created by Yannian Liu on 6/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation

extension Product {
    func getIndexPathInCategorySummaryDict(categorySummaryDict: [Category:ExpandableSectionInFridge], categoryArray:[Category]) -> IndexPath? {
        guard let aCategory = self.category else {return nil}
        guard let section = categoryArray.index(of: aCategory) else {return nil}
        var row: Int = 0
        var isRowExist = false
        guard let aExp = categorySummaryDict[aCategory] else {return nil}
        if aExp.content.count == 0 {
            isRowExist = false
        } else {
            for i in 0...aExp.content.count-1 {
                if aExp.content[i].product == self {
                    row = i
                    isRowExist = true
                    break
                }
            }
        }
        var indexPath = IndexPath()
        if isRowExist == true {
            indexPath = IndexPath(row: row, section: section)
            return indexPath
        } else {
            print("There is no this product in FridgeFoodSummary Array")
            return nil
        }
    }
    
    func getTotalQuantityInPurchaseArray(array: [Purchase])->Int{
        var qt = 0
        for each in array {
            qt = qt + each.quantityToInt()
        }
        return qt
    }
}
