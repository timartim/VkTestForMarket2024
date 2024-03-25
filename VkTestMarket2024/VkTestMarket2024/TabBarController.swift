//
//  TabBarController.swift
//  VkTestMarket2024
//
//  Created by Артемий on 19.03.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        let vc = WeatherAtUsersLocationController()
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "UserWeatherIcon"), tag: 0)
        let vc2 = FindWeatherController()
        vc2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "FindWeatherIcon"), tag: 1)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        vc2.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        self.viewControllers = [vc, vc2]
        
    }
}
