//
//  HomeViewController.swift
//  PARD
//
//  Created by 김민섭 on 3/4/24.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {
    private var esterEggCount = 0
    private let logoImageViewTag = 999          // 로고 식별을 위한 태그
    
    private lazy var topView = HomeTopView(viewController: self).then { view in
        view.backgroundColor = .pard.blackCard
        view.layer.cornerRadius = 40.0
        view.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 40)
        view.layer.masksToBounds = true
    }
    
    private lazy var pardnerShipView = HomePardnerShipView(viewController: self).then { view in
        view.backgroundColor = .pard.blackCard
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    private lazy var upcommingView = HomeUpcommingView(viewController : self).then { view in
        view.backgroundColor = .pard.blackCard
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .pard.blackCard
        appearance.shadowColor = .pard.blackCard
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        let menuButton = UIBarButtonItem(
            image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexibleSpace.width = 10
        self.navigationItem.rightBarButtonItems = [flexibleSpace, menuButton]
    }
    
    // 네비게이션바 로고 추가
    private func addLogoToNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        // 중복 추가 방지
        if navBar.viewWithTag(logoImageViewTag) != nil { return }
        
        let logoImageView = UIImageView(image: UIImage(named: "pardHomeLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.isUserInteractionEnabled = true
        logoImageView.tag = logoImageViewTag
        
        // 탭 제스처
        let logoTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        logoImageView.addGestureRecognizer(logoTapGesture)
        
        navBar.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 20),
            logoImageView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor)
        ])
    }
    
    // 네비게이션바 로고 제거
    private func removeLogoFromNavigationBar() {
        navigationController?.navigationBar.viewWithTag(logoImageViewTag)?.removeFromSuperview()
    }
    
    
    @objc private func logoTapped() {
        print("tapped")
        esterEggCount += 1
        
        if (esterEggCount == 10) {
            print("10 됐음 !! ")
            esterEggCount = 0
            
            if let url = URL(string: "https://we-pard.notion.site/d5e1d460c05844c4b810816ff502d5db?pvs=4") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        let menuBar = HamburgerBarViewController()
        menuBar.modalPresentationStyle = .overCurrentContext
        menuBar.didDismiss = { [weak self] in
            self?.tabBarController?.tabBar.isHidden = false
        }
        if #available(iOS 15, *) {
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                topViewController.present(menuBar, animated: false)  // animated를 false로 설정
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
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        addLogoToNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeLogoFromNavigationBar()
    }
    
    private func setUpUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(pardnerShipView)
        contentView.addSubview(upcommingView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
        
        pardnerShipView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(140)
        }
        
        upcommingView.snp.makeConstraints { make in
            make.top.equalTo(pardnerShipView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
