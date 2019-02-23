//
//  CategoryCreateCustomCategoryViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 12/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class CategoryCreateCategoryViewController: AppPopSwipeForCreatingViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    

    var categoryArray : [Category] = []
    
    weak var delegate: CategoryViewControllerDelegate?

    
    lazy var imageInerView: UIImageView = {
        let image = UIImage()
        let iv = UIImageView(image:image)
        iv.frame.size.width = AppLayoutParameter.imageHeightSmall
        iv.setRoundShape()
        iv.clipsToBounds = true
        iv.tintColor = UIColor.appColour2Medium
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let cellId = "cellId"
    var imageArray :[UIImage] = []
    lazy var collectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let frame = CGRect (x: 0, y: 0, width: 100, height: 100)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: AppLayoutParameter.buttonLengthBig, height: AppLayoutParameter.buttonLengthBig)
        button.setRoundShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.appColour1Medium
        button.addShadow()
        button.setTemplateImage(imageName: "checkMark", tintColour: .white)
        button.addTarget(self, action: #selector(handleCreateCategoryViewSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = fetchData()
        imageArray = CategoryImage.imageArray
        setupView()
        setupCollectionView()
    }
    
    // - - - - - - - - - - - - - - Setup Style - - - - - - - - - - - - - - //
    
    func setupView(){
        view.backgroundColor = UIColor.white
        
        setupPopViewControllerBasic(containerViewHeight: AppLayoutParameter.containerHeightMini,containerViewLocation: .top, title: "Create a Category")
        setupPopSwipeForCreatingViewControllerBasic()
        
        // part 1 - image

        imageView.addSubview(imageInerView)
        let imageInerViewHeight = imageInerView.frame.size.width
        imageInerView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        imageInerView.widthAnchor.constraint(equalToConstant: imageInerViewHeight).isActive = true
        imageInerView.heightAnchor.constraint(equalToConstant: imageInerViewHeight).isActive = true
        imageInerView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        // part 2 - sheet 1
        sheetView1.addSubview(collectionView)
        let collectionViewWidth = containerView.frame.size.width - AppLayoutParameter.marginSmall*2
        collectionView.topAnchor.constraint(equalTo: sheetView1.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: collectionViewWidth).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: sheetView1.bottomAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: sheetView1.centerXAnchor).isActive = true
        
        // part 3 - sheet 2
        
        sheetView2.addSubview(saveButton)
        let saveButtonDiameter = saveButton.frame.size.width
        saveButton.centerXAnchor.constraint(equalTo: sheetView2.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: sheetView2.bottomAnchor, constant: -(AppLayoutParameter.marginBig + saveButtonDiameter/2)).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButtonDiameter).isActive = true
        
    }
    
    // - - - - - - - - - - - - - - Collection View - - - - - - - - - - - - - - //

    func setupCollectionView(){
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CategoryCreateCategoryCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCreateCategoryCollectionCell
        aCell.image = imageArray[indexPath.row]
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let perWidth = totalWidth/8
        return CGSize(width:perWidth, height: perWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageInerView.image = imageArray[indexPath.row].withRenderingMode(.alwaysTemplate)
        imageInerView.backgroundColor = UIColor.white
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.appColour1Medium
        for each in imageArray.indices {
            let otherIndexPath = IndexPath(row: each, section: 0)
            if otherIndexPath != indexPath {
                collectionView.cellForItem(at: otherIndexPath)?.backgroundColor = UIColor.white

            }
        }
        isAllowToProgress = true
        blockAnimateFrom1To2()
    }
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    
    @objc func handleCreateCategoryViewSaveButton(){
        // initialization of our core data
        guard let aName = nameTextField.text else {return}
        if nameTextField.text == "" {
            showAlertWithCancel(title: "Empty Name", message: "You have not entered a name.")
            return
        }
        guard  let aImage = imageInerView.image else {return}
        let aOrder = categoryArray.count
        
        guard let category = CoreDataManager.shared.createCategory(name: aName, image: aImage, order: aOrder, isDefault: false) else {return}
        self.containerView.animatePulse {
            self.navigationController?.popViewController(animated: false)
            self.delegate?.handleCategoryCreateCategoryDidSave(category: category)
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
