//
//  PardNotionLinkView.swift
//  PARD
//
//  Created by 진세진 on 3/20/24.
//

import UIKit
import Then
import SnapKit
import PARD_DesignSystem

class PardNotionLinkView: UIView {
    private let identifier = "pardNotionCell"
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: 200, height: 48)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.register(PardNotionLinkCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        $0.backgroundColor = .pard.blackCard
    }
    
    convenience init(superView : UIView) {
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionViewUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpCollectionViewUI() {
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
extension PardNotionLinkView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PardNotionLinkData.menuTableModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PardNotionLinkCollectionViewCell else {
            return UICollectionViewCell()
        }
        let pardNotionData = PardNotionLinkData.menuTableModel[indexPath.row]
        cell.configuarePardNotionCell(partName: pardNotionData.title)
        cell.backgroundColor = .gradientColor.gra
        
        if pardNotionData.title == "iOS 파트" {
            cell.bottomLine.isHidden = false
        } else {
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let pardNotionData = PardNotionLinkData.menuTableModel[indexPath.row]
       if let url = URL(string: pardNotionData.notionLink) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
   }
}

extension PardNotionLinkView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// - MARK: PardNotionLinkData 모델
struct PardNotionLinkData {
    let title : String
    let notionLink : String
}

extension PardNotionLinkData {
   static let menuTableModel = [
        PardNotionLinkData(title: "전체", notionLink: "https://www.notion.so/we-pard/PARD-5-1ac9fe7667e68042b5a9dcb1fce1cea0"),
        PardNotionLinkData(title: "기획 파트", notionLink: "https://www.notion.so/we-pard/1a79fe7667e680a5a660ed3d9a946eb9"),
        PardNotionLinkData(title: "디자인 파트", notionLink: "https://www.notion.so/we-pard/UX-UI-1ac9fe7667e680f1863bce8e70559b36"),
        PardNotionLinkData(title: "웹 파트", notionLink: "https://www.notion.so/we-pard/1ac9fe7667e68005bdb7f35d573a28b5"),
        PardNotionLinkData(title: "서버 파트", notionLink: " https://www.notion.so/we-pard/1ac9fe7667e68059b7f8f2364aa56b8d"),
        PardNotionLinkData(title: "iOS 파트", notionLink: "https://www.notion.so/we-pard/iOS-1b49fe7667e680de89fbd5cc7828d172")
    ]
}
