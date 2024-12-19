//
//  HamburgerBarViewController.swift
//  PARD
//
//  Created by 진세진 on 3/5/24.
//

import UIKit

// - MARK: HamburgerBar
class HamburgerBarViewController: UIViewController {
    private let dimmedView = UIView().then { dimmedView in
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0)
    }
    
    private var hamburgerBar: HamburgerBarView!
    var didDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHamburgerBarUI()
        self.tabBarController?.tabBar.isHidden = true
        
        hamburgerBar.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        dimmedView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.hamburgerBar.transform = .identity
            self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.dimmedView.alpha = 1.0
        }
    }
    
    private func setUpHamburgerBarUI() {
        hamburgerBar = HamburgerBarView(superview: self.view)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapedDimmedView)
        )
        
        dimmedView.addGestureRecognizer(tapGesture)
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.bringSubviewToFront(hamburgerBar)
    }
    
    @objc private func didTapedDimmedView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.hamburgerBar.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.dimmedView.alpha = 0
        }) { _ in
            self.dismiss(animated: false) {
                self.didDismiss?()
            }
        }
    }
}
