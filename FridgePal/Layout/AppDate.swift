//
//  AppDate.swift
//  FridgePal
//
//  Created by Yannian Liu on 2/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
