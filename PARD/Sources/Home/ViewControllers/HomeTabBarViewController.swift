//
//  HomeTableViewController.swift
//  PARD
//
//  Created by 김민섭 on 3/4/24.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pard.blackBackground
        self.navigationController?.navigationBar.isHidden = false
        setUpTabbarView()
        setUpTabBarColor()
        setUpTabBarLayout()
        setUpTabBarItems()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    private func setUpTabbarView() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -12, right: 0)
        
        let myPageViewController = MyPageViewController()
        myPageViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "person"), tag: 1)
        myPageViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -12, right: 0)
        
        let navigationHome = UINavigationController(rootViewController: homeViewController)
        let navigationMypage = UINavigationController(rootViewController: myPageViewController)
        setViewControllers([navigationHome, navigationMypage], animated: false)
    }
    
    private func setUpTabBarColor() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .pard.blackCard
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .pard.gray30
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .pard.gra
        
        if #available(iOS 15.0, *) {
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .pard.blackCard
        tabBar.unselectedItemTintColor = .pard.gray30
        tabBar.selectedItem?.badgeColor = .pard.gra
    }
    
    private func setUpTabBarLayout() {
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        tabBar.itemWidth = 18
        tabBar.itemPositioning = .centered
    }
    
    private func setUpTabBarItems() {
           self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
           self.title = nil
       }
}

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 64
        return sizeThatFits
    }
}
