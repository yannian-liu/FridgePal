//
//  FridgeAddPurchaseView+ContainerView1.swift
//  FridgePal
//
//  Created by Yannian Liu on 9/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

extension FridgeAddPurchaseViewController {
    // - - - - - - - - - - - - - - Set up - - - - - - - - - - - - - - //
    func setupAddFoodContainerView1(){
        // - - - - - Up to Down - - - - - //
        containerView1.addSubview(titleLabel)
        let titleLabelHeight = AppLayoutParameter.labelHeightTitle
        let titleLabelWidth = AppLayoutParameter.labelHeightTitle*3
        titleLabel.topAnchor.constraint(equalTo: containerView1.topAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabelWidth).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView1.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true

        // - - - - - Down to Up - - - - - //
        
        
        // - - - - - Flexible - - - - - //
        
        containerView1.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: containerView1.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView1.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView1.bottomAnchor, constant: -AppLayoutParameter.marginBig).isActive = true

    }
    // - - - - - - - - - - - - - - Header - - - - - - - - - - - - - - //
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.appColour1Medium
        label.font = UIFont.appFontBodyMedium
        label.text = tableViewSectionArray[section]
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppLayoutParameter.headerHeightSmall
    }

    // - - - - - - - - - - - - - - Cell - - - - - - - - - - - - - - //

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArrayArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FridgeAddPurchaseCell(style: .default, reuseIdentifier: cellId)
        cell.nameLabel.text = productArrayArray[indexPath.section][indexPath.row].name
        if let imageData = productArrayArray[indexPath.section][indexPath.row].image {
            cell.foodImageView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeightSmall
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.product = productArrayArray[indexPath.section][indexPath.row]
        isAllowToProgress = true
        handleProgress()
    }
    
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //

    // - - - - - - - - - - - - - - Basic - - - - - - - - - - - - - - //

    func setupDataForTableView(){
        productArrayArray = []
        guard let productArray = CoreDataManager.shared.fetchProducts(predicate: nil, sortArray: nil) else {return}
        var starArray = productArray.filter { (product) -> Bool in
            return product.isStarred == true
        }
        starArray.sort { (p1, p2) -> Bool in
            if let name1 = p1.name, let name2 = p2.name {
                return name1.lowercased() < name2.lowercased()
            } else {
                return false
            }
        }
        productArrayArray = [starArray]
        
        for i in 1...tableViewSectionArray.count-1 {
            var eachArray = productArray.filter { (product) -> Bool in
                if let aName = product.name {
                    return aName.lowercased().first == tableViewSectionArray[i].lowercased().first
                } else {return false}
            }
            eachArray.sort { (p1, p2) -> Bool in
                if let name1 = p1.name, let name2 = p2.name {
                    return name1.lowercased() < name2.lowercased()
                } else {
                    return false
                }
            }
            productArrayArray.append(eachArray)
        }
    }
}
