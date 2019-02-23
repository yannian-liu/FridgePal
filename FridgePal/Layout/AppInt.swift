//
//  AppInt.swift
//  FridgePal
//
//  Created by Yannian Liu on 20/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
extension Int16 {
    func toInt () -> Int {
        guard let aQtInt = Int("\(self)") else {return 0 }
        return aQtInt
    }
}
