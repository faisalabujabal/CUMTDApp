//
//  TabBarController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/11/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = RGBA(hex: "#122847")?.getUIColor()
        self.tabBar.tintColor = RGBA(hex: "#FA6300")?.getUIColor()
    }
}
