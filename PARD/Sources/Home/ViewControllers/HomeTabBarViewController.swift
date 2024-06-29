//
//  HomeTableViewController.swift
//  PARD
//
//  Created by 김민섭 on 3/4/24.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
    private let floatingButton = UIButton().then { button in
        button.layer.cornerRadius = 40
        button.backgroundColor = .pard.gra
        button.setImage(UIImage(named: "scan")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pard.blackBackground
        self.navigationController?.navigationBar.isHidden = false
        setUpTabbarView()
        setUpTabBarColor()
        setUpTabBarLayout()
        setUpTabBarItems()
        delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        setUpfloatingQRButton()
    }
    
    private func setUpfloatingQRButton() {
        self.view.addSubview(floatingButton)
                
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-24)
        }
                
        floatingButton.addTarget(self, action: #selector(floatingQRButtonTapped), for: .touchUpInside)
    }
    
    @objc private func floatingQRButtonTapped() {
        print("tapped qr code page")
        let QRVC = ReaderViewController()
        navigationController?.pushViewController(QRVC, animated: true)
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
        sizeThatFits.height = 10
        return sizeThatFits
    }
}

extension HomeTabBarViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let tabBarItemIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if tabBarItemIndex == 0 {
                floatingButton.isEnabled = true
            } else {
                floatingButton.isEnabled = false
            }
        }
    }
}
