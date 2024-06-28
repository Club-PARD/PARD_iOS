//
//  HomeViewController.swift
//  PARD
//
//  Created by 김민섭 on 3/4/24.
//

import UIKit

class HomeViewController: UIViewController {

    private let topView = HomeTopView().then { view in
        view.backgroundColor = .pard.blackCard
        view.layer.cornerRadius = 40.0
        view.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 40)
        view.layer.masksToBounds = true
        
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let pardnerShipView = HomePardnerShipView().then {
        view in
        view.backgroundColor = .pard.blackCard
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    private func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .pard.blackCard
        appearance.shadowColor = .pard.blackCard
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let homeButton = UIBarButtonItem(image: UIImage(named: "pardHomeLogo")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(homeLogoTapped))
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexibleSpace.width = 10
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItems = [flexibleSpace,menuButton]
    }
    
    @objc private func homeLogoTapped() {
        print("home")
        // FIXME: - ram test code
    }
   
    @objc private func menuButtonTapped() {
        print("sese")
        let menuBar = HamburgerBarViewController()
        menuBar.modalPresentationStyle = .overCurrentContext
        menuBar.modalTransitionStyle = .crossDissolve
        menuBar.didDismiss = { [weak self] in
            self?.tabBarController?.tabBar.isHidden = false
        }
        if #available(iOS 15, *) {
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                    topViewController.present(menuBar, animated: true)
            }
        }
    }
}

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pard.blackBackground
        setUpUI()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setUpUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(pardnerShipView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
        
        pardnerShipView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(140)
        }
    }
}
