//
//  ExpandableSection.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/21.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import Foundation

class ExpandableSectionInFridge {
    var isExpanded: Bool = true
    var content: [FridgeFoodSummary] = []
    init(isExpanded: Bool, content: [FridgeFoodSummary]) {
        self.isExpanded = isExpanded
        self.content = content
    }
}

class ExpandableSectionInCategory {
    var isExpanded: Bool = true
    var content: [Product] = []
    
    init(isExpanded: Bool, content: [Product]) {
        self.isExpanded = isExpanded
        self.content = content
    }
}

class GroupInCategory {
    var category : Category
    var content: [Product] = []
    
    init(category: Category, content: [Product]) {
        self.category = category
        self.content = content
    }
}
