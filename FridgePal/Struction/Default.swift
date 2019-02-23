//
//  Default.swift
//  FridgePal
//
//  Created by Yannian Liu on 20/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import Foundation
import UIKit

struct Default {
    static let shared = Default()
    
    let categoryNameArray: [String] = ["Fruit","Veg","Meat","Seafood","Bakery","Dairy","Eggs","Meals","Pantry","Freezer","Drinks","Liquor","Baby","Pet"]
    
    let imageNameArray:[String] = ["plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus","plus"]
    
    lazy var imageArray:[UIImage] = {
        var array:[UIImage] = []
        for i in 0...imageNameArray.count-1{
            guard let image = UIImage(named: imageNameArray[i]) else {return []}
            array.append(image)
        }
        return array
    }()
    
    mutating func setDefaultCategoryAndProduct(){
        let categoryOrder = 0
        for i in 0...categoryNameArray.count-1{
            guard let category = CoreDataManager.shared.createCategory(name: categoryNameArray[categoryOrder], image: imageArray[i], order: categoryOrder, isDefault: true) else {return}
            generateProducts(category: category)
        }

    }
    
    func generateProducts(category: Category){
        
    }
}

struct CategoryImage {
    static let imageNameArray:[String] = ["star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","star","star","star","star","star","star","star","star","star","star","star"]
    
    static let imageArray:[UIImage] = {
        var array : [UIImage] = []
        array = imageNameArray.map({ (name) -> UIImage in
            if let image = UIImage(named: name) {
                let tintedImage = image
                return tintedImage
            } else {
                print("Error: can not find the image")
                return UIImage()
            }
        })
        return array
    }()
}

struct ProductImage {
    static let imageNameArray:[String] = ["star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","star","star","star","star","star","star","star","star","star","star","star","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","star","star","star","star","star","star","star","star","star","star","star","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","star","star","star","star","star","star","star","star","star","star","star","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","Untitled","plus","star","star","star","star","star","star","star","star","star","star","star","star"]
    
    static let imageArray:[UIImage] = {
        var array : [UIImage] = []
        array = imageNameArray.map({ (name) -> UIImage in
            if let image = UIImage(named: name) {
                return image
            } else {
                print("Error: can not find the image")
                return UIImage()
            }
        })
        return array
    }()
}
