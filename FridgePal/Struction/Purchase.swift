//
//  Purchase.swift
//  FridgePal
//
//  Created by Yannian Liu on 5/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import ObjectiveC

private var xoAssociationKey: UInt8 = 0

enum MergeStyle {
    case insertCategoryAndSummary, insertSummary, update
}

extension Purchase {
    var mergeStyle: MergeStyle! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? MergeStyle
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func mergeIntoFridgeCategorySummaryDict(categorySummaryDict: inout [Category:ExpandableSectionInFridge]){
        guard let aProduct = self.product else {return}
        guard let aCategory = aProduct.category else {return}
        let aQt = self.quantityToInt()
        guard let aDate = self.date else {return}
        // check category exist
        if categorySummaryDict[aCategory] != nil {
            guard let aExp = categorySummaryDict[aCategory] else {return}
            // check summary exist
            var isSummaryExist = false
            
            for i in aExp.content.indices {
                if aProduct == aExp.content[i].product {
                    isSummaryExist = true
                    self.mergeStyle = MergeStyle.update
                    aExp.content[i].totalQuantity = aExp.content[i].totalQuantity + aQt
                    if aDate.compare(aExp.content[i].earliestPurchaseDate) == .orderedAscending {
                        aExp.content[i].earliestPurchaseDate = aDate
                        aExp.content[i].earliestPurchaseQuantity = aQt
                    }
                    break
                }
            }
            
            if isSummaryExist == false {
                // did not found a same name one
                self.mergeStyle = .insertSummary
                let aSummary = FridgeFoodSummary(product: aProduct, totalQuantity: aQt, earliestPurchaseDate: aDate, earliestPurchaseQuantity: aQt )
                aExp.content.append(aSummary)
            }
        } else {
            // no category
            // insert category
            self.mergeStyle = .insertCategoryAndSummary
            let aSummary = FridgeFoodSummary(product: aProduct, totalQuantity: aQt, earliestPurchaseDate: aDate, earliestPurchaseQuantity: aQt )
            let aExpandableSection = ExpandableSectionInFridge(isExpanded: true, content: [aSummary])
            categorySummaryDict.updateValue(aExpandableSection, forKey: aCategory)
        }
    }
    
    func quantityToInt() -> Int {
        guard let aQtInt = Int("\(self.quantity)") else {return 0}
        return aQtInt
    }
    
    func dateToDate() -> Date {
        guard let aDate = self.date else {return Date()}
        return aDate
    }
}
