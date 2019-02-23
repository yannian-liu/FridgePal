//
//  Dictionary.swift
//  FridgePal
//
//  Created by Yannian Liu on 10/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
extension Dictionary where Value: Equatable {
    /// Returns all keys mapped to the specified value.
    /// ```
    /// let dict = ["A": 1, "B": 2, "C": 3]
    /// let keys = dict.keysForValue(2)
    /// assert(keys == ["B"])
    /// assert(dict["B"] == 2)
    /// ```
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
    
}
