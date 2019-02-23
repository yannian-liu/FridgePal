//
//  FridgeAddFoodView.swift
//  FridgePal
//
//  Created by Yannian Liu on 25/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class FridgeAddPurchaseViewController: AppPopTwoViewController, UITableViewDataSource, UITableViewDelegate {

    // - - - - - - - - - - - - - - containerView 1 - - - - - - - - - - - - - - //
    
    var productArrayArray: [[Product]] = [[]]
    
    var titleLabel : UILabel = {
        let tl = UILabel()
        tl.font = UIFont.appFontTitle3
        tl.textColor = UIColor.appColour2Dark
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "Please choose a food"
        tl.textAlignment = .center
        return tl
    }()
    
    let cellId : String = "cellID"
    let tableViewSectionArray = ["☆","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FridgeAddPurchaseCell.self, forCellReuseIdentifier: cellId)
//        tableView.register(FridgeHeader.self, forHeaderFooterViewReuseIdentifier: fridgeHeaderId)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.appColourGrayMedium
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // - - - - - - - - - - - - - - containerView 2 - - - - - - - - - - - - - - //

    weak var delegate: FridgeViewControllerDelegate?
    
    var product : Product? {
        didSet {
            if let aProduct = product {
                purchaseArray = fetchPurchaseWith(product: aProduct)
                nameLabel.text = aProduct.name
                totalQuantity = aProduct.getTotalQuantityInPurchaseArray(array: purchaseArray)
            }
        }
    }
    
    var purchaseArray: [Purchase] = []
    var totalQuantity = 0 {
        didSet {
            detailLabel.text = "You have \(totalQuantity) in your fridge."
        }
    }
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Untitled"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontTitle2
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Appleqweruiopzxcvjkl;b"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let purchaseDateTitileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Purchased Date:"
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.layer.cornerRadius = AppLayoutParameter.cornerRadius
        //dp.layer.borderWidth = AppLayoutParameter.borderWidth
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.setValue(1, forKey: "alpha")
        dp.setValue(UIColor.appColour2Dark, forKey: "textColor")
        dp.setValue(true, forKey: "highlightsToday")
        return dp
    }()
    
    var quantity : Int = 1 {
        didSet {
            self.quantityLabel.text = "\(quantity)"
        }
    }
    
    let quantityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Quantity:"
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont.appFontTitle2
        label.textAlignment = .center
        return label
    }()
    
    lazy var reduceButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeAddPurchaseViewReduceButton), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthSmall, height: AppLayoutParameter.buttonLengthSmall)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour2Dark
        button.addTarget(self, action: #selector(handleFridgeAddPurchaseViewAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthBig, height: AppLayoutParameter.buttonLengthBig)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addShadow()
        button.addTarget(self, action: #selector(handleFridgeAddPurchaseViewSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataForTableView()
        setupView()
    }
    
    // - - - - - - - - - - - - - - Set Up - - - - - - - - - - - - - - //

    func setupView(){
        setupPopViewControllerBasic(containerViewHeight: AppLayoutParameter.containerHeightBig)
        
        setupDataForTableView()
        setupAddFoodContainerView1()
        setupAddFoodContainerView2()
    }
    
    // - - - - - - - - - - - - - - Block - - - - - - - - - - - - - - //

    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    
    // - - - - - - - - - - - - - - base - - - - - - - - - - - - - - //
}
