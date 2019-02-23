//
//  CoreDataManager.swift
//  FridgePal
//
//  Created by Yannian Liu on 26/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too.
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FridgePalModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    // - - - - - - - - - - - - - - Purchase - - - - - - - - - - - - - - //

    func fetchPurchases(predicate: NSPredicate?, sortArray: [NSSortDescriptor]?)->[Purchase]?{
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Purchase>(entityName: "Purchase")
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sortArray != nil {
            fetchRequest.sortDescriptors = sortArray
        }
        do {
            let purchaseArray = try context.fetch(fetchRequest)
            return purchaseArray
        } catch let fetchErr {
            print("Failed to fetch purchase: ", fetchErr)
            return nil
        }
    }
    
    func deletePurchase(purchase: Purchase) {
        let context = persistentContainer.viewContext
        context.delete(purchase)
        do {
            print("start to delete the category")
            try context.save()
        } catch let saveErr {
            print("Failed to delete a purchase: ", saveErr)
        }
    }
    
    // - - - - - - - - - - - - - - Shopping - - - - - - - - - - - - - - //
    func deleteShopping(shopping: Shopping) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(shopping)
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete a shopping from fridge: ", saveErr)
        }
    }
    
    // - - - - - - - - - - - - - - Product - - - - - - - - - - - - - - //
    
    func fetchProducts(predicate: NSPredicate?, sortArray: [NSSortDescriptor]?)->[Product]?{
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sortArray != nil {
            fetchRequest.sortDescriptors = sortArray
        }
        do {
            let productArray = try context.fetch(fetchRequest)
            return productArray
        } catch let fetchErr {
            print("Failed to fetch products: ", fetchErr)
            return nil
        }
    }

    func createProduct(name: String, image: UIImage, energy: Int, isDefault: Bool, isStarred: Bool, category: Category) -> Product?{
        let context = persistentContainer.viewContext
        let aProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
        aProduct.name = name
        let imageData = image.pngData()
        aProduct.image = imageData
        aProduct.energy = Int16(energy)
        aProduct.isDefault = isDefault
        aProduct.isStarred = isStarred
        aProduct.category = category
        do{
            try context.save()
            return aProduct
        } catch let err{
            print("Failed to create category: ", err)
            return nil
        }
    }
    
    func deleteProduct(product: Product) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(product)
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete a product : ", saveErr)
        }
    }

    // - - - - - - - - - - - - - - Category - - - - - - - - - - - - - - //
    
    func fetchCategories(predicate: NSPredicate?, sortArray: [NSSortDescriptor]?)->[Category]?{
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sortArray != nil {
            fetchRequest.sortDescriptors = sortArray
        }
        do {
            let categoryArray = try context.fetch(fetchRequest)
            return categoryArray
        } catch let fetchErr {
            print("Failed to fetch purchase: ", fetchErr)
            return nil
        }
    }
    
    func createCategory(name: String, image: UIImage, order: Int, isDefault: Bool) -> Category?{
        let context = persistentContainer.viewContext
        let aCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        aCategory.name = name
        let imageData = image.pngData()
        aCategory.image = imageData
        let order16 = Int16(order)
        aCategory.order = order16
        aCategory.isDefault = isDefault
        do{
            try context.save()
            return aCategory
        } catch let err{
            print("Failed to create category: ", err)
            return nil
        }
    }
    
    func saveCategory(category: Category, name: String, image: UIImage, order: Int, isDefault: Bool) -> Category?{
        let context = persistentContainer.viewContext
        category.name = name
        let imageData = image.pngData()
        category.image = imageData
        let order16 = Int16(order)
        category.order = order16
        category.isDefault = isDefault
        do{
            try context.save()
            return category
        } catch let err{
            print("Failed to save category: ", err)
            return nil
        }
    }
    
    func deleteCategory(category: Category) {
        // change other categories' orders
        let order = category.order
        if let categoryArray = CoreDataManager.shared.fetchCategories(predicate: nil, sortArray: nil) {
            for each in categoryArray {
                if each.order > order {
                    each.order = Int16(each.order.toInt()-1)
                }
                let context = CoreDataManager.shared.persistentContainer.viewContext
                do {
                    try context.save()
                } catch let saveErr {
                    print("Failed to change order to other categorys: ", saveErr)
                    return
                }
            }
        }
        
        // delete this category
        let context = persistentContainer.viewContext
        context.delete(category)
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete a category: ", saveErr)
        }
    }
}
