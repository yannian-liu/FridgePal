//
//  CategoryViewController.swift
//  FridgePal
//
//  Created by Yannian Liu on 2/11/18.
//  Copyright © 2018 Yannian Liu. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryViewControllerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate {

    var groupArray : [GroupInCategory] = []

    let categoryCellId = "categoryCellId"
    let categoryHeaderId = "categoryHeaderId"
    
    var indexPathOfInsertedCellForScrolling : IndexPath? = nil
    var indexPathOfInsertedHeaderForScrolling: IndexPath? = nil
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.frame.size = CGSize(width: UIScreen.main.bounds.width/3, height: 10)
        searchBar.layer.borderWidth = AppLayoutParameter.borderWidth
        searchBar.layer.borderColor = UIColor.appColour1Medium.cgColor
        searchBar.setRoundCornerShape()
        return searchBar
    }()
    
    lazy var manageCategoryButton : UIButton = {
        let button = UIButton()
        button.frame.size.height = AppLayoutParameter.navigationItemHeight
        let origImage = UIImage(named: "plusCategory")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour1Medium
        button.setRoundCornerShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCategoryManageCategoryButton), for: .touchUpInside)
        return button
    }()
    
    lazy var createCategoryButton : UIButton = {
        let button = UIButton()
        button.frame.size.height = AppLayoutParameter.navigationItemHeight
        let origImage = UIImage(named: "plusCategory")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour1Medium
        button.setRoundCornerShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCategoryCreateCategoryButton), for: .touchUpInside)
        return button
    }()
    
    lazy var createProductButton : UIButton = {
        let button = UIButton()
        button.frame.size.height = AppLayoutParameter.navigationItemHeight
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor.appColour1Medium
        button.setRoundCornerShape()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCategoryCreateProductButton), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellId)
        tableView.register(CategoryHeader.self, forHeaderFooterViewReuseIdentifier: categoryHeaderId)
        tableView.tableFooterView = UIView()
        //        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var indexListView : CategoryIndexListView = {
        let categoryArray = makeCategoryArray()
        var viewHeightMax: CGFloat = 0.0
        if let navi = navigationController {
            viewHeightMax = UIScreen.main.bounds.height - navi.navigationBar.bounds.height - AppLayoutParameter.tabBarHeight - AppLayoutParameter.marginBig*2
        } else {
            viewHeightMax = UIScreen.main.bounds.height - AppLayoutParameter.tabBarHeight - AppLayoutParameter.marginBig*2
        }
        
        let view = CategoryIndexListView(categoryArray: categoryArray, viewHeightMax: viewHeightMax)
        view.translatesAutoresizingMaskIntoConstraints = false

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.0
        lpgr.delegate = self
        view.addGestureRecognizer(lpgr)
        view.isUserInteractionEnabled = true
        return view
    }()
    var indexListViewWidthConstraint: NSLayoutConstraint? = nil
    var indexListViewHeightConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGroupArray()
        setupView()
    }
    
    // - - - - - - - - - - - - - - Setup Style - - - - - - - - - - - - - - //
    
    func setupView(){
        view.backgroundColor = UIColor.white
        
        guard let naviBar = navigationController?.navigationBar else {
            print("This viewController do not have navigationBar")
            return
        }
        let buttonHeight =  AppLayoutParameter.navigationItemHeight

        // navigation bar : left -> right
        naviBar.addSubview(searchBar)
        let searchBarWidth = searchBar.frame.size.width
        searchBar.centerYAnchor.constraint(equalTo: naviBar.centerYAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        searchBar.leftAnchor.constraint(equalTo: naviBar.leftAnchor, constant: AppLayoutParameter.marginSmall).isActive = true

        // navigation bar : right -> left
        naviBar.addSubview(createProductButton)
        createProductButton.centerYAnchor.constraint(equalTo: naviBar.centerYAnchor).isActive = true
        createProductButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        createProductButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        createProductButton.rightAnchor.constraint(equalTo: naviBar.rightAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        
        naviBar.addSubview(createCategoryButton)
        createCategoryButton.centerYAnchor.constraint(equalTo: naviBar.centerYAnchor).isActive = true
        createCategoryButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        createCategoryButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        createCategoryButton.rightAnchor.constraint(equalTo: createProductButton.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        
        naviBar.addSubview(manageCategoryButton)
        manageCategoryButton.centerYAnchor.constraint(equalTo: naviBar.centerYAnchor).isActive = true
        manageCategoryButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        manageCategoryButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        manageCategoryButton.rightAnchor.constraint(equalTo: createCategoryButton.leftAnchor, constant: -AppLayoutParameter.marginSmall).isActive = true
        
        // - - - - - - - - - - -
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppLayoutParameter.indexListWidthMax).isActive = true
        
        view.addSubview(indexListView)
        let indexListViewWidth = indexListView.frame.size.width
        let indexListViewHeight = indexListView.frame.size.height
        indexListView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -AppLayoutParameter.tabBarHeight/2).isActive = true
        indexListViewWidthConstraint = indexListView.widthAnchor.constraint(equalToConstant: indexListViewWidth)
        indexListViewWidthConstraint?.isActive = true
        indexListViewHeightConstraint = indexListView.heightAnchor.constraint(equalToConstant: indexListViewHeight)
        indexListViewHeightConstraint?.isActive = true
        indexListView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    // - - - - - - - - - - - - - - Header - - - - - - - - - - - - - - //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupArray.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: categoryHeaderId) as! CategoryHeader
        let aCategory = groupArray[section].category
        aHeader.tag = section
        aHeader.delegate = self
        aHeader.category = aCategory
        return aHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AppLayoutParameter.headerHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return AppLayoutParameter.headerHeight
    }
    
    // - - - - - - - - - - - - - - Cell - - - - - - - - - - - - - - //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray[section].content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: categoryCellId, for: indexPath) as! CategoryCell
        let product = groupArray[indexPath.section].content[indexPath.row]
        aCell.product = product
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeightSmall
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppLayoutParameter.cellHeightSmall
    }
    
    // - - - - - - - - - - - - - - Scroll View - - - - - - - - - - - - - - //

    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = indexPathOfInsertedCellForScrolling {
            tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
            indexPathOfInsertedCellForScrolling = nil
        }
        if let indexPath = indexPathOfInsertedHeaderForScrolling {
            tableView.headerView(forSection: indexPath.section)?.animatePulse {}
            indexPathOfInsertedHeaderForScrolling = nil
        }
    }
    
    // - - - - - - - - - - - - - - Button Function - - - - - - - - - - - - - - //
    
    @objc func handleCategoryManageCategoryButton(){
        let manageCategoryVC = CategoryManageCategoryViewController()
        manageCategoryVC.delegate = self
        self.pushAppPopViewController(viewControllerPushed: manageCategoryVC)
    }
    
    func handleCategoryManageCategoryDidDelete(category: Category) {
        guard let section = blockGetCategoryIndex(category: category) else {return}
        groupArray.remove(at: section)
        tableView.deleteSections([section], with: .fade)
        blockIndexListViewUpdate()
    }
    
    func handleCategoryManageCategoryDidEdit(category: Category) {
        guard let section = blockGetCategoryIndex(category: category) else {return}
        let indexPath = IndexPath (row: NSNotFound, section: section)
        tableView.reloadRows(at: [indexPath], with: .fade)
        blockIndexListViewUpdate()
    }
    
    func handleCategoryManageCategoryDidMove(category: Category) {
        guard let section = blockGetCategoryIndex(category: category) else {return}
        let group = groupArray[section]
        groupArray.remove(at: section)
        groupArray.insert(group, at: category.order.toInt())
        tableView.reloadData()
        blockIndexListViewUpdate()
    }
    

    @objc func handleCategoryCreateCategoryButton(){
        let createCategoryVC = CategoryCreateCategoryViewController()
        createCategoryVC.delegate = self
        self.pushAppPopViewController(viewControllerPushed: createCategoryVC)
    }
    
    func handleCategoryCreateCategoryDidSave(category: Category){
        let aGroup = GroupInCategory(category: category, content: [])
        groupArray.append(aGroup)
        let section = category.order.toInt()
        let sectionIndexPath = IndexPath(row: NSNotFound, section: section)
        blockInsertSectionTableViewUpdate(indexPath: sectionIndexPath)
        blockIndexListViewUpdate()
        
    }
    
    @objc func handleCategoryCreateProductButton(){
        let createProductVC = CategoryCreateProductViewController()
        createProductVC.delegate = self
        self.pushAppPopViewController(viewControllerPushed: createProductVC)
    }

    func handleCategoryCreateProductDidSave(product: Product) {
        guard let category = product.category else {return}
        let section = category.order.toInt()
        let aGroup = groupArray[section]
        aGroup.content.append(product)
        aGroup.content.sort { (p1, p2) -> Bool in
            if let name1 = p1.name, let name2 = p2.name {
                return name1.lowercased() < name2.lowercased()
            } else {
                return false
            }
        }
        guard let row = aGroup.content.index(of: product) else {return}
        let indexPath = IndexPath(row: row, section: section)
        blockInsertRowTableViewUpdate(indexPath: indexPath)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began || gesture.state == .changed {
            let pressedLocation = gesture.location(in: self.indexListView)
            let hitTestView = indexListView.hitTest(pressedLocation, with: nil)
            if hitTestView is UIImageView {
                blockPressAnIcon(hitTestView: hitTestView as! UIImageView)
                if let index = indexListView.imageViewArray.index(of: hitTestView as! UIImageView) {
                    let indexPath = IndexPath(row: NSNotFound, section: index)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        } else {
            blockPressNone()
        }
    }
    
    // - - - - - - - - - - - - - - block - - - - - - - - - - - - - - //
    
    func blockInsertSectionTableViewUpdate(indexPath: IndexPath){
        tableView.insertSections([indexPath.section], with: .none)
        
        let headerRect = tableView.rectForHeader(inSection: indexPath.section)
        let isCompletelyVisible = tableView.bounds.contains(headerRect)
        if isCompletelyVisible == false {
            self.indexPathOfInsertedHeaderForScrolling = indexPath
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            guard let header = tableView.headerView(forSection: indexPath.section) else {return}
            header.animatePulse {}
        }
    }
    
    func blockInsertRowTableViewUpdate(indexPath: IndexPath){
        tableView.insertRows(at: [indexPath], with: .none)
        let cellRect = tableView.rectForRow(at: indexPath)
        let isCompletelyVisible = tableView.bounds.contains(cellRect)
        if isCompletelyVisible == false {
            self.indexPathOfInsertedCellForScrolling = indexPath
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) else {return}
            cell.animatePulseWithDelay {}
        }
    }
    
    func blockReloadRowTableViewUpdate(indexPath: IndexPath){
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.cellForRow(at: indexPath)?.animatePulseWithDelay{}
    }
    
    func blockDeleteRowTableViewUpdate(indexPath: IndexPath){
        tableView.deleteRows(at: [indexPath], with: .fade)
        if groupArray[indexPath.section].content.count == 0 {
            groupArray.remove(at: indexPath.section)
            tableView.headerView(forSection: indexPath.section)?.animatePulseWithDelay{}
            tableView.deleteSections([indexPath.section], with: .fade)
        }
    }
    
    func blockPressAnIcon(hitTestView: UIImageView){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            let stackView = self.indexListView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            hitTestView.transform = CGAffineTransform(translationX: -50, y: 0)
        }, completion: nil)
    }
    
    func blockPressNone(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            let stackView = self.indexListView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
        }, completion: nil)
    }
    
    func blockGetCategoryIndex(category: Category) -> Int? {
        let array:[Category] = makeCategoryArray()
        guard let section = array.index(of: category) else {return nil}
        return section
    }
    
    func blockIndexListViewUpdate(){
        indexListView.reset(categoryArray: makeCategoryArray())
        indexListViewHeightConstraint?.constant = indexListView.frame.size.height
        indexListViewWidthConstraint?.constant = indexListView.frame.size.width
        view.layoutIfNeeded()
    }
    
    // - - - - - - - - - - - - - - data basic - - - - - - - - - - - - - - //
    func makeGroupArray(){
        groupArray = []
        let categoryArray = fetchData()
        
        for each in categoryArray {
            guard let array = each.product?.allObjects as? [Product] else {return}
            let productArray = array.sorted(by: { (p1, p2) -> Bool in
                if let name1 = p1.name, let name2 = p2.name {
                    return name1.lowercased() < name2.lowercased()
                } else {
                    return false
                }
            })
            let aGroup = GroupInCategory(category: each, content: productArray)
            groupArray.append(aGroup)

        }
    }
    
    func makeCategoryArray()->[Category]{
        let array:[Category] = groupArray.map { (group) -> Category in
            let aCategory = group.category
            return aCategory
        }
        return array
    }
    
    func fetchData()->[Category]{
        let sort = NSSortDescriptor(key: #keyPath(Category.order), ascending: true)
        guard let categoryArray = CoreDataManager.shared.fetchCategories(predicate: nil, sortArray: [sort]) else {return []}
        return categoryArray
    }
}
