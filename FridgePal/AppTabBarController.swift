//
//  ViewController.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        let fridgeViewController = FridgeViewController()
        let fridgeNavigationController = UINavigationController(rootViewController: fridgeViewController)
        
        //2

        let popTowVC = AppPopTwoViewController()
        let popTowVCnvi = UINavigationController(rootViewController: popTowVC)
        //3
        let categoryViewController = CategoryViewController()
        let categoryNavigationController = UINavigationController(rootViewController: categoryViewController)
        
        //4
        let settingViewController = SettingViewController()
        let settingNavigationController = UINavigationController(rootViewController: settingViewController)
        
        //....
        viewControllers = [fridgeNavigationController, popTowVCnvi, categoryNavigationController, settingNavigationController]
        
        tabBar.items?[0].title = "Fridge"
        tabBar.items?[1].title = "Shopping List"
        tabBar.items?[2].title = "Category"
        tabBar.items?[3].title = "Setting"
    }
}
