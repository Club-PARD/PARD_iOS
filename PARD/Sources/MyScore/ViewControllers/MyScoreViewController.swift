//
//  MyScoreViewController.swift
//  PARD
//
//  Created by 김민섭 on 3/4/24.
//

import UIKit
import Then
import SnapKit
import PARD_DesignSystem

class MyScoreViewController: UIViewController, UIGestureRecognizerDelegate {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let questionImageButton = UIButton().then {
        $0.setImage(UIImage(named: "myscore-question-line")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let contentView = UIView()
    private let pardnerShipLabel = UILabel().then { label in
        label.text = "🏆 PARDNERSHIP TOP 3 🏆"
        label.font = UIFont.pardFont.head2
        label.textColor = UIColor.gradientColor.gra
        label.textAlignment = .center
    }
    let labelContainerView = UIView().then { label in
        label.backgroundColor = .clear
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gradientColor.gra.cgColor
        label.layer.cornerRadius = 18
    }
    private var scoreRecordsView = ScoreRecordsView()
    private var toolTipView: ToolTIpViewInMyScore?
    private var scoreRecords: [ReasonPardnerShip] = []
    private var rank1: Rank?
    private var rank2: Rank?
    private var rank3: Rank?
    
    private let appearance = UINavigationBarAppearance().then {
        $0.configureWithOpaqueBackground()
        $0.backgroundColor = .pard.blackBackground
        $0.shadowColor = .pard.blackBackground
        $0.titleTextAttributes = [
            .foregroundColor: UIColor.pard.white100,
            .font: UIFont.pardFont.head1
        ]
    }
    
    private let previousAppearance = UINavigationBarAppearance().then {
        $0.configureWithOpaqueBackground()
        $0.backgroundColor = .pard.blackCard
        $0.shadowColor = .pard.blackCard
    }
  
    private func loadData() {
        getRankMe { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateUIWithRanks()
                self.setupScoreView()
            }
        }

        getRankTop3 { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ranks) :
                DispatchQueue.main.async {
                    RankManager.shared.rankList = ranks
                    self.updateUIWithRanks()
                    self.setupRankingMedals()
                }
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isNotUser()
                    self.setupRankingMedals()
                }
                print(error.localizedDescription)
                break
            }
        }
        
        getReason { [weak self] reasons in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.scoreRecords = reasons
                self.scoreRecordsView.configure(with: reasons)
                print("데이터 로드 완료: \(self.scoreRecords)")
            }
        }
    }
    
    private func updateUIWithRanks() {
        if RankManager.shared.rankList.count >= 3 {
            rank1 = RankManager.shared.rankList[0]
            rank2 = RankManager.shared.rankList[1]
            rank3 = RankManager.shared.rankList[2]
        } else {
            print("Not enough data in rankList or not register your id")
        }
    }

    private func setNavigation() {
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .font:  UIFont.pardFont.head2,
                .foregroundColor: UIColor.pard.white100
            ]
        }
        self.navigationItem.title = "내 점수"
        appearance.shadowColor = .clear
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupTextLabel() {
        let padding: CGFloat = 8
        contentView.addSubview(labelContainerView)
        labelContainerView.addSubview(pardnerShipLabel)
        
        labelContainerView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(230 + padding * 2)
            $0.height.equalTo(36)
        }
        
        pardnerShipLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding))
        }
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        // 스와이프 제스처 추가
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        swipeGesture.delegate = self
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        // 수평 스와이프만 처리
        if abs(translation.x) > abs(translation.y) {
            if gesture.state == .ended {
                if translation.x > 50 || velocity.x > 500 {
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func isNotUser() {
        if RankManager.shared.rankList.isEmpty {
            print("파웅우루루루루루룰")
            RankManager.shared.rankList = [Rank.init(part: "PARD", name: "팡울이")]
            rank1 = RankManager.shared.rankList[0]
            rank2 = RankManager.shared.rankList[0]
            rank3 = RankManager.shared.rankList[0]
        }
    }
    
    private func setupRankingMedals() {
        let goldRingImageView = UIImageView(image: UIImage(named: "goldRing"))
        contentView.addSubview(goldRingImageView)
        
        let goldRankLabel = UILabel().then {
            $0.text = "1"
            $0.font = UIFont.pardFont.head2
            $0.textAlignment = .center
            $0.textColor = .white
        }
        contentView.addSubview(goldRankLabel)
        
        let goldPartLabel = UILabel().then {
            $0.text = "\(rank1?.part ?? "PARD")"
            $0.font = UIFont.pardFont.body2
            $0.textAlignment = .center
            $0.textColor = .pard.gray30
        }
        contentView.addSubview(goldPartLabel)
        
        let goldNameLabel = UILabel().then {
            $0.text = "\(rank1?.name ?? "팡울이")"
            $0.font = UIFont.pardFont.body4
            $0.textAlignment = .center
            $0.textColor = .pard.gray10
        }
        contentView.addSubview(goldNameLabel)
        
        let silverRingImageView = UIImageView(image: UIImage(named: "silverRing"))
        contentView.addSubview(silverRingImageView)
        
        let silverRankLabel = UILabel().then {
            $0.text = "2"
            $0.font = UIFont.pardFont.head2
            $0.textAlignment = .center
            $0.textColor = .white
        }
        contentView.addSubview(silverRankLabel)
        
        let silverPartLabel = UILabel().then {
            $0.text = "\(rank2?.part ?? "PARD")"
            $0.font = UIFont.pardFont.body2
            $0.textAlignment = .center
            $0.textColor = .pard.gray30
        }
        contentView.addSubview(silverPartLabel)
        
        let silverNameLabel = UILabel().then {
            $0.text = "\(rank2?.name ?? "팡울이")"
            $0.font = UIFont.pardFont.body4
            $0.textAlignment = .center
            $0.textColor = .pard.gray10
        }
        contentView.addSubview(silverNameLabel)
        
        let bronzeRingImageView = UIImageView(image: UIImage(named: "bronzeRing"))
        contentView.addSubview(bronzeRingImageView)
        
        let bronzeRankLabel = UILabel().then {
            $0.text = "3"
            $0.font = UIFont.pardFont.head2
            $0.textAlignment = .center
            $0.textColor = .white
        }
        contentView.addSubview(bronzeRankLabel)
        
        let bronzePartLabel = UILabel().then {
            $0.text = "\(rank3?.part ?? "PARD")"
            $0.font = UIFont.pardFont.body2
            $0.textAlignment = .center
            $0.textColor = .pard.gray30
        }
        contentView.addSubview(bronzePartLabel)
        
        let bronzeNameLabel = UILabel().then {
            $0.text = "\(rank3?.name ?? "팡울이")"
            $0.font = UIFont.pardFont.body4
            $0.textAlignment = .center
            $0.textColor = .pard.gray10
        }
        contentView.addSubview(bronzeNameLabel)
        
        goldRingImageView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(40)
        }
        
        goldRankLabel.snp.makeConstraints {
            $0.centerX.equalTo(goldRingImageView)
            $0.centerY.equalTo(goldRingImageView)
        }
        
        goldPartLabel.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.centerX.equalTo(goldNameLabel.snp.centerX)
            $0.bottom.equalTo(goldNameLabel.snp.top).offset(-2)
        }
        
        goldNameLabel.snp.makeConstraints {
            $0.top.equalTo(goldPartLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(70)
        }
        
        silverRingImageView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(146)
            $0.width.height.equalTo(40)
        }
        
        silverRankLabel.snp.makeConstraints {
            $0.centerX.equalTo(silverRingImageView)
            $0.centerY.equalTo(silverRingImageView)
        }
        
        silverPartLabel.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.centerX.equalTo(silverNameLabel.snp.centerX)
            $0.bottom.equalTo(silverNameLabel.snp.top).offset(-2)
        }
        
        silverNameLabel.snp.makeConstraints {
            $0.top.equalTo(silverPartLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(194)
        }
        
        bronzeRingImageView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.trailing.equalToSuperview().offset(-81)
            $0.width.height.equalTo(40)
        }
        
        bronzeRankLabel.snp.makeConstraints {
            $0.centerX.equalTo(bronzeRingImageView)
            $0.centerY.equalTo(bronzeRingImageView)
        }
        
        bronzePartLabel.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(25)
            $0.centerX.equalTo(bronzeNameLabel.snp.centerX)
            $0.bottom.equalTo(bronzeNameLabel.snp.top).offset(-2)
        }
        
        bronzeNameLabel.snp.makeConstraints {
            $0.top.equalTo(bronzePartLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().offset(-36)
        }
        
        let goldCrownImageView = UIImageView(image: UIImage(named: "gold"))
        contentView.addSubview(goldCrownImageView)
        
        goldCrownImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32)
            $0.top.equalTo(goldRingImageView.snp.top).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        let silverCrownImageView = UIImageView(image: UIImage(named: "silver"))
        contentView.addSubview(silverCrownImageView)
        
        silverCrownImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(156)
            $0.top.equalTo(silverRingImageView.snp.top).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        let bronzeCrownImageView = UIImageView(image: UIImage(named: "bronze"))
        contentView.addSubview(bronzeCrownImageView)
        
        bronzeCrownImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-91)
            $0.top.equalTo(bronzeRingImageView.snp.top).offset(-10)
            $0.width.height.equalTo(20)
        }
    }
    
    private func setupScoreView() {
        print(UserDefaults.standard.string(forKey: "partRanking") ?? "위")
        let myScoreBorderView = UIView().then {
            $0.backgroundColor = UIColor.pard.blackCard
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gradientColor.gra.cgColor
        }
        contentView.addSubview(myScoreBorderView)
        
        myScoreBorderView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(89)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(view.snp.centerX).offset(-12)
            $0.height.equalTo(68)
        }
        
        let totalScoreBorderView = UIView().then {
            $0.backgroundColor = UIColor.pard.blackCard
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gradientColor.gra.cgColor
        }
        
        contentView.addSubview(totalScoreBorderView)
        
        totalScoreBorderView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(89)
            $0.leading.equalTo(view.snp.centerX).offset(12)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(68)
        }
        
        let rankingButton = UIButton(type: .system).then {
            $0.setTitle("전체 랭킹 확인하기", for: .normal)
            $0.setTitleColor(.pard.gray30, for: .normal)
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(rankingButtonTapped), for: .touchUpInside)
        }
        contentView.addSubview(rankingButton)
        
        rankingButton.snp.makeConstraints {
            $0.centerX.equalTo(totalScoreBorderView.snp.centerX).offset(33)
            $0.top.equalTo(totalScoreBorderView.snp.bottom).offset(14)
            $0.width.equalTo(90)
            $0.height.equalTo(18)
        }
        
        
        let transparentButton = UIButton().then {
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(rankingButtonTapped), for: .touchUpInside)
        }
        contentView.addSubview(transparentButton)
        
        transparentButton.snp.makeConstraints {
            $0.edges.equalTo(rankingButton).inset(UIEdgeInsets(top: -15, left: -10, bottom: -15, right: -10))
        }
        
        let attributedString = NSMutableAttributedString(string: "전체 랭킹 확인하기", attributes: [
            .font: UIFont.pardFont.body1,
            .foregroundColor: UIColor.pard.gray30
        ])
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        rankingButton.setAttributedTitle(attributedString, for: .normal)
        
        let myScoreLabel = UILabel().then {
            $0.text = "파트 내 랭킹"
            $0.font = UIFont.pardFont.body2
            $0.textAlignment = .center
            $0.textColor = .pard.gray10
        }
        contentView.addSubview(myScoreLabel)
        
        myScoreLabel.snp.makeConstraints {
            $0.top.equalTo(myScoreBorderView.snp.top).offset(12)
            $0.centerX.equalTo(myScoreBorderView.snp.centerX)
        }
        
        let myRankLabel = UILabel().then {
            $0.text = "\(UserDefaults.standard.string(forKey: "partRanking") ?? "-")위"
            $0.font = UIFont.pardFont.head2
            $0.textAlignment = .center
            $0.textColor = .white
        }
        contentView.addSubview(myRankLabel)
        
        myRankLabel.snp.makeConstraints {
            $0.top.equalTo(myScoreLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(myScoreBorderView.snp.centerX)
        }
        
        let totalScoreLabel = UILabel().then {
            $0.text = "전체 랭킹"
            $0.font = UIFont.pardFont.body2
            $0.textAlignment = .center
            $0.textColor = .pard.gray10
        }
        contentView.addSubview(totalScoreLabel)
        
        totalScoreLabel.snp.makeConstraints {
            $0.top.equalTo(totalScoreBorderView.snp.top).offset(12)
            $0.centerX.equalTo(totalScoreBorderView.snp.centerX)
        }
        
        let totalRankLabel = UILabel().then {
            $0.text = "\(UserDefaults.standard.string(forKey: "totalRanking") ?? "-")위"
            $0.font = UIFont.pardFont.head2
            $0.textAlignment = .center
            $0.textColor = .white
        }
        contentView.addSubview(totalRankLabel)
        
        totalRankLabel.snp.makeConstraints {
            $0.top.equalTo(totalScoreLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(totalScoreBorderView.snp.centerX)
        }
    }
    
    private func setupScoreStatusView() {
        let scoreStatusLabel = UILabel().then {
            $0.text = "내 점수 현황"
            $0.font = UIFont.pardFont.head1
            $0.textColor = .white
            $0.textAlignment = .left
        }
        contentView.addSubview(scoreStatusLabel)
        
        scoreStatusLabel.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(211)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview().offset(260)
        }
        
        let scoreStatusView = UIView().then {
            $0.backgroundColor = UIColor.pard.blackCard
            $0.layer.cornerRadius = 8
        }
        contentView.addSubview(scoreStatusView)
        
        scoreStatusView.snp.makeConstraints {
            $0.top.equalTo(scoreStatusLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(92)
        }
        
        let partPointsView = UIView().then {
            $0.backgroundColor = .clear
        }
        scoreStatusView.addSubview(partPointsView)

        let penaltyPointsView = UIView().then {
            $0.backgroundColor = .clear
        }
        
        scoreStatusView.addSubview(penaltyPointsView)

        partPointsView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(scoreStatusView).multipliedBy(0.5)
        }

        penaltyPointsView.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(scoreStatusView).multipliedBy(0.5)
        }
        
        let partPointsLabel = UILabel().then {
            $0.text = "파드 포인트"
            $0.font = UIFont.pardFont.body2
            $0.textColor = .pard.gray10
            $0.textAlignment = .center
        }
        partPointsView.addSubview(partPointsLabel)

        
        partPointsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }

        
        let partPointsValueLabel = UILabel().then {
            let bonus = UserDefaults.standard.string(forKey: "userTotalBonus") ?? "0"
            if userRole.contains("ADMIN"){
                $0.text = "-"
            } else {
                $0.text = "+\(bonus)점"
            }
            $0.font = UIFont.pardFont.head2
            $0.textColor = UIColor.pard.primaryGreen
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
        partPointsView.addSubview(partPointsValueLabel)

        partPointsValueLabel.snp.makeConstraints {
            $0.top.equalTo(partPointsLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        let separatorView = UIView().then {
            $0.backgroundColor = .pard.gray30
        }
        
        scoreStatusView.addSubview(separatorView)
        
        separatorView.snp.makeConstraints {
            $0.centerX.equalTo(scoreStatusView)
            $0.centerY.equalTo(scoreStatusView)
            $0.width.equalTo(1)
            $0.height.equalTo(44)
        }
        
        let penaltyPointsLabel = UILabel().then {
            $0.text = "벌점"
            $0.font = UIFont.pardFont.body2
            $0.textColor = .pard.gray10
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
        penaltyPointsView.addSubview(penaltyPointsLabel)
        
        let penaltyPointsValueLabel = UILabel().then {
            let minus = UserDefaults.standard.string(forKey: "userTotalMinus") ?? "0"
            if userRole.contains("ADMIN"){
                $0.text = "-"
            } else {
                $0.text = "+\(minus)점"
            }
            $0.font = UIFont.pardFont.head2
            $0.textColor = UIColor.pard.errorRed
            $0.textAlignment = .center
            
        }
        penaltyPointsView.addSubview(penaltyPointsValueLabel)
        
        penaltyPointsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }

        penaltyPointsValueLabel.snp.makeConstraints {
            $0.top.equalTo(penaltyPointsLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func tappedQuestionButton() {
        toggleToolTip()
    }
    
    @objc private func scorePolicyTapped() {
        toggleToolTip()
    }
    
    private var backgroundTapGesture: UITapGestureRecognizer?

    private func toggleToolTip() {
        if toolTipView == nil {
            let toolTip = ToolTIpViewInMyScore()
            view.addSubview(toolTip)
            toolTip.snp.makeConstraints { make in
                make.top.equalTo(questionImageButton.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-18)
                make.height.equalTo(200)
            }
            toolTipView = toolTip
            
            backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
            backgroundTapGesture?.cancelsTouchesInView = false
            view.addGestureRecognizer(backgroundTapGesture!)
            
            toolTipView?.isUserInteractionEnabled = true
            let toolTipTapGesture = UITapGestureRecognizer(target: self, action: #selector(dummyAction))
            toolTipView?.addGestureRecognizer(toolTipTapGesture)
        }
    }
    
    @objc private func backgroundTapped() {
        toolTipView?.removeFromSuperview()
        toolTipView = nil
        
        if let gesture = backgroundTapGesture {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    @objc private func dummyAction() {
        
    }
    
    private func setupScoreRecordsView() {
        let scoreRecordsTitleLabel = UILabel().then {
            $0.text = "점수 기록"
            $0.font = UIFont.pardFont.head1
            $0.textColor = .white
            $0.textAlignment = .left
        }
        contentView.addSubview(scoreRecordsTitleLabel)

        
        questionImageButton.addTarget(self, action: #selector(tappedQuestionButton), for: .touchUpInside)
        
        let scorePolicyLabel = UILabel().then {
            $0.text = "점수 정책 확인하기"
            $0.font = UIFont.pardFont.body2
            $0.textColor = .pard.primaryBlue
            $0.textAlignment = .right
            $0.isUserInteractionEnabled = true
        }
        
        
        let scorePolicyTapGesture = UITapGestureRecognizer(target: self, action: #selector(scorePolicyTapped))
        scorePolicyLabel.addGestureRecognizer(scorePolicyTapGesture)
        
        contentView.addSubview(scorePolicyLabel)
        contentView.addSubview(questionImageButton)
        contentView.addSubview(scoreRecordsView)
        scoreRecordsView.layer.cornerRadius = 12
        scoreRecordsView.layer.masksToBounds = true
        scoreRecordsView.configure(with: scoreRecords)
        
        // Constraints for title label, question image, and policy label
        scoreRecordsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(375)
            $0.leading.equalToSuperview().offset(28)
        }
        
        questionImageButton.snp.makeConstraints {
            $0.centerY.equalTo(scoreRecordsTitleLabel)
            $0.trailing.equalTo(scorePolicyLabel.snp.leading).offset(-2)
            $0.width.height.equalTo(14) // Adjust size as needed
        }
        
        scorePolicyLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreRecordsTitleLabel)
            $0.leading.equalTo(questionImageButton.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().offset(-28)
        }
        
        scoreRecordsView.snp.makeConstraints {
            $0.top.equalTo(scoreRecordsTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(136)
        }
    }

    @objc private func rankingButtonTapped() {
        let rankingViewController = RankingViewController()
        navigationController?.pushViewController(rankingViewController, animated: true)
    }
}

extension MyScoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        view.backgroundColor = .pard.blackBackground
        setupTextLabel()
        setNavigation()
        loadData()
        setupScoreView()
        setupScoreStatusView()
        setupScoreRecordsView()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        removeTabBarFAB(bool: true)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.standardAppearance = previousAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = previousAppearance
        removeTabBarFAB(bool: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func removeTabBarFAB(bool: Bool) {
        self.tabBarController?.setTabBarVisible(visible: !bool, animated: false)
        if let tabBarViewController = tabBarController as? HomeTabBarViewController {
            tabBarViewController.floatingButton.isHidden = bool
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: view)
            return abs(translation.x) > abs(translation.y)
        }
        return true
    }
}

