//
//  CreateCategoryViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 31/10/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import Photos
import CoreData

class CategoryCreateProductViewController: AppPopSwipeForCreatingViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var categoryArray: [Category] = []
    weak var delegate: CategoryViewControllerDelegate?

    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Please Choose a Icon"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionBgView: DashedBorderView = {
        let view = DashedBorderView(borderColor: UIColor.appColour2Medium, dashPaintedSize: 5, dashUnpaintedSize: 5, lineWidth: AppLayoutParameter.borderWidthBig)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellId = "cellId"
    private var imageArray :[UIImage] = []
    private var isEditingimage : Bool = true
    var collectionViewSelectedIndexPath :IndexPath? = nil
    lazy var collectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let frame = CGRect (x: 0, y: 0, width: 100, height: 100)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CategoryCreateProductCollectionCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    let starredLabel : UILabel = {
        let label = UILabel()
        label.text = "Starred"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let starredSwitch : UISwitch = {
        let aSwitch = UISwitch()
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.tintColor = UIColor.appColour2Medium
        aSwitch.onTintColor = UIColor.appColour2Medium
        return aSwitch
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Please Choose a Category"
        label.font = UIFont.appFontBody
        label.textColor = UIColor.appColour2Dark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryPicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        picker.setValue(UIColor.appColour2Dark, forKey: "textColor")
        picker.layer.cornerRadius = AppLayoutParameter.cornerRadius
        picker.layer.borderWidth = AppLayoutParameter.borderWidthBig
        picker.layer.borderColor = UIColor.appColour2Medium.cgColor
        return picker
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthBig, height: AppLayoutParameter.buttonLengthBig)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addShadow()
        button.addTarget(self, action: #selector(handleCategoryCreateProductSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray = ProductImage.imageArray
        categoryArray = fetchData()
        setupView()
    }
    
    // - - - - - - - - - - - - - - Setup Style - - - - - - - - - - - - - - //
    
    func setupView(){
        setupPopViewControllerBasic(containerViewHeight: AppLayoutParameter.containerHeightBig,containerViewLocation: .centre, title: "Create a Food")
        setupPopSwipeForCreatingViewControllerBasic()

        // - - - - - sheet view 1 - - - - - //

        sheetView1.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: sheetView1.topAnchor).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: sheetView1.leftAnchor).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: sheetView1.rightAnchor ).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant:AppLayoutParameter.labelHeightContent).isActive = true
        
        
        sheetView1.addSubview(collectionBgView)
        let collectionBgViewWidth = containerView.frame.size.width - AppLayoutParameter.marginSmall*2
        collectionBgView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor,constant: AppLayoutParameter.marginSmall).isActive = true
        collectionBgView.leftAnchor.constraint(equalTo: sheetView1.leftAnchor,constant: AppLayoutParameter.marginSmall).isActive = true
        collectionBgView.widthAnchor.constraint(equalToConstant: collectionBgViewWidth).isActive = true
        collectionBgView.bottomAnchor.constraint(equalTo: sheetView1.bottomAnchor).isActive = true

        
        collectionBgView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: collectionBgView.topAnchor,constant: AppLayoutParameter.marginSmall/2).isActive = true
        collectionView.leftAnchor.constraint(equalTo: collectionBgView.leftAnchor,constant: AppLayoutParameter.marginSmall/2).isActive = true
        collectionView.rightAnchor.constraint(equalTo: collectionBgView.rightAnchor,constant: -AppLayoutParameter.marginSmall/2).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: collectionBgView.bottomAnchor,constant: -AppLayoutParameter.marginSmall/2).isActive = true
        
        // - - - - - sheet view 2 - - - - - //
        
        // Up to Down //
        
        sheetView2.addSubview(starredLabel)
        let starredLabelHeight = AppLayoutParameter.labelHeightContent
        let starredLabelWidth = containerView.frame.size.width/2 - AppLayoutParameter.marginBig
        starredLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        starredLabel.rightAnchor.constraint(equalTo: sheetView2.centerXAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        starredLabel.widthAnchor.constraint(equalToConstant: starredLabelWidth).isActive = true
        starredLabel.heightAnchor.constraint(equalToConstant: starredLabelHeight).isActive = true

        sheetView2.addSubview(starredSwitch)
        starredSwitch.centerYAnchor.constraint(equalTo: starredLabel.centerYAnchor).isActive = true
        starredSwitch.leftAnchor.constraint(equalTo: sheetView2.centerXAnchor, constant: AppLayoutParameter.marginSmall).isActive = true

        sheetView2.addSubview(categoryLabel)
        let categoryLabelHeight = AppLayoutParameter.labelHeightContent
        let categoryLabelWidth = containerView.frame.size.width
        categoryLabel.topAnchor.constraint(equalTo: starredLabel.bottomAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: sheetView2.leftAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: categoryLabelWidth).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: categoryLabelHeight).isActive = true

        // - - - - - Down to Up - - - - - //

        sheetView2.addSubview(saveButton)
        let saveButtonDiameter = saveButton.frame.size.width
        saveButton.centerXAnchor.constraint(equalTo: sheetView2.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: sheetView2.bottomAnchor, constant: -(AppLayoutParameter.marginBig + saveButtonDiameter/2)).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true

        // - - - - - Flexible - - - - - //

        sheetView2.addSubview(categoryPicker)
        categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: AppLayoutParameter.marginSmall).isActive = true
        categoryPicker.leftAnchor.constraint(equalTo: sheetView2.leftAnchor, constant: AppLayoutParameter.marginBig).isActive = true
        categoryPicker.rightAnchor.constraint(equalTo: sheetView2.rightAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        categoryPicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -AppLayoutParameter.marginBig).isActive = true
        
    }
    
    // - - - - - - - - - - - - - - Collection View - - - - - - - - - - - - - - //


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCreateProductCollectionCell
        cell.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageView.image = imageArray[indexPath.row]
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.appColour2Light
        for each in imageArray.indices {
            let otherIndexPath = IndexPath(row: each, section: 0)
            if otherIndexPath != indexPath {
                collectionView.cellForItem(at: otherIndexPath)?.backgroundColor = UIColor.white
            }
        }
        isAllowToProgress = true
        blockAnimateFrom1To2()
    }    
    
    // - - - - - - - - - - - - - - PickerView - - - - - - - - - - - - - - //
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].name
    }
    
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //

    
    @objc private func handleCategoryCreateProductSaveButton(){
        if nameTextField.text == "" {
            showAlertWithCancel(title: "Empty Name", message: "You have not entered a name.")
            return
        }
        // initialization of our core data
        guard let aName = nameTextField.text else {return}
        var aImage = UIImage()
        guard let defaultImage = UIImage(named: "plus") else {return}
        if let image = imageView.image {
            aImage = image
        } else {
            aImage = defaultImage
        }
        let aEnergy = 200
        let aIsStarred = starredSwitch.isOn
        let row = categoryPicker.selectedRow(inComponent: 0)
        let aCategory = categoryArray[row]
        guard let aProduct = CoreDataManager.shared.createProduct(name: aName, image: aImage, energy: aEnergy, isDefault: false, isStarred: aIsStarred, category: aCategory) else {return}
        self.containerView.animatePulse {
            self.navigationController?.popViewController(animated: false)
            self.delegate?.handleCategoryCreateProductDidSave(product: aProduct)
        }
    }
    

    // - - - - - - - - - - - - - - block - - - - - - - - - - - - - - //

    
    // - - - - - - - - - - - - - - basic - - - - - - - - - - - - - - //
    func fetchData()->[Category]{
        let sort = NSSortDescriptor(key: #keyPath(Category.order), ascending: true)
        guard let categoryArray = CoreDataManager.shared.fetchCategories(predicate: nil, sortArray: [sort]) else {return []}
        return categoryArray
    }
}
