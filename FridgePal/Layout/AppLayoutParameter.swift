//
//  AppLayoutParameter.swift
//  FridgePal
//
//  Created by yannian liu on 2018/9/20.
//  Copyright © 2018年 Yannian Liu. All rights reserved.
//

import UIKit

class AppLayoutParameter {
    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· layout ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
    static let marginSmall:CGFloat = UIScreen.main.bounds.size.height/56 // 896.0/16
    static let marginMedium : CGFloat = marginSmall*1.5
    static let marginBig:CGFloat = marginSmall*2

    static let containerHeightBig : CGFloat = 650
    static let containerHeightMedium: CGFloat = 550
    static let containerHeightSmall: CGFloat = 450
    static let containerHeightMini: CGFloat = 350
    
    static let navigationItemHeight : CGFloat = 44/3*2 // iPhone x max NAVIBAR = 44
    
    static let tabBarHeight : CGFloat = 100
    static let bannerHeight : CGFloat = marginSmall*6

    static let headerHeight : CGFloat = UIScreen.main.bounds.size.height/18 // 896.0/50
    static let headerHeightSmall : CGFloat = UIScreen.main.bounds.size.height/25 // 896.0/35

    static let cellHeight: CGFloat = UIScreen.main.bounds.size.height/12 // 896.0/75
    static let cellHeightSmall: CGFloat = UIScreen.main.bounds.size.height/15 // 896.0/60
    static let cellHeightMini: CGFloat = UIScreen.main.bounds.size.height/18 // 896.0/50

    
    static let collectionCellHeight: CGFloat = UIScreen.main.bounds.size.height/26 // 896.0/32
    
    static let labelHeightContent: CGFloat = UIScreen.main.bounds.size.height/35 // 896.0/35
    static let labelHeightTitle: CGFloat = UIScreen.main.bounds.size.height/22 // 896.0/40
    
    static let textFieldHeight: CGFloat = UIScreen.main.bounds.size.height/18 //896.0/50

    
    static let buttonLengthSmall: CGFloat = UIScreen.main.bounds.size.height/28 // 896.0/32
//    static let buttonLengthSmall: CGFloat = UIScreen.main.bounds.size.height/30 // 896.0/30
    static let buttonLengthBig: CGFloat = UIScreen.main.bounds.size.height/13 // 896.0/70
    
    static let imageHeightSmall = labelHeightTitle
    static let imageHeightBig = imageHeightSmall*2

    static let datePickerHeight: CGFloat = buttonLengthBig*2.5
    
    static let cornerRadius: CGFloat = 10.0
    static let cornerRadiusMini: CGFloat = 5.0
    static let shadowRadius: CGFloat = 5.0
    static let backgroundViewOpacity: CGFloat = 0.5
    static let borderWidth: CGFloat = 1.0
    static let borderWidthBig: CGFloat = 2.0

    static let indexListWidthMax : CGFloat = UIScreen.main.bounds.size.height/18 // 896.0/50
    
}

enum ContainerViewLocation {
    case top, centre
}
