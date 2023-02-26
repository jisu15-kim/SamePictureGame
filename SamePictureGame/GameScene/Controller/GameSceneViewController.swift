//
//  GameSceneViewController.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/11.
//

import UIKit
import CoreData
import AVFoundation

class GameSceneViewController: UIViewController {
    
    var sfxPlayer: AVAudioPlayer?
    
    var delegate: GameSceneDelegate?
    
    var bgmToggleView: BGMToggleView = {
        let view = BGMToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var cardFlipLifeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    
    var dataManager: GameDataManager?
    var setting: GameSetting?
    var cardData: [GameData] = []
    var cardFlipLife: Int = 0 {
        didSet {
            print("남은 횟수: \(cardFlipLife)")
            cardFlipLifeLabel.text = "\(cardFlipLife)"
        }
    }
    var timer: Timer!
    var gamePlayTime = 0
    var startRow = 0
    
    // Match된 카드의 갯수 // 10개
    private var cardMatchCount: Int = 0 {
        didSet {
            if cardMatchCount == (setting!.getRow() * setting!.getColumn()) / 2 {
                self.gameClear()
            }
        }
    }
    
    private var flipedCard: [CardCell] = []
    
    @IBOutlet weak var gameZoneCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataManager = GameDataManager(cardCount: (setting!.getRow() * setting!.getColumn()) / 2)
        setupGameData()
        setupSettingButton()
        setupBgmToggleView()
        setupCollectionView()
        firstHint()
    }
    
    func setupBgmToggleView() {
        self.view.addSubview(bgmToggleView)
        NSLayoutConstraint.activate([
            self.bgmToggleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            self.bgmToggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.bgmToggleView.widthAnchor.constraint(equalTo: bgmToggleView.heightAnchor, multiplier: 1.0),
            self.bgmToggleView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupGameData() {
        self.cardData = dataManager!.getCardData(isShuffle: true)
        self.cardFlipLife = setting!.getLifeCount()
        print("남은 횟수: \(cardFlipLife)")
        self.cardFlipLifeLabel.text = "\(self.cardFlipLife)"
        self.gamePlayTime = 0
        self.cardMatchCount = 0
        self.timeLabel.text = "\(gamePlayTime)"
        
        self.scoreView.layer.cornerRadius = 20
        self.scoreView.clipsToBounds = true
        
        self.scoreView.layer.shadowColor = UIColor.darkGray.cgColor
        self.scoreView.layer.shadowRadius = 10
        self.scoreView.layer.masksToBounds = false
        self.scoreView.layer.shadowOpacity = 0.7
        self.scoreView.layer.shadowOffset = CGSize(width: 5, height: 10)
    }
    
    private func setupSettingButton() {
        self.settingImageView.isUserInteractionEnabled = true
        let recog = UITapGestureRecognizer(target: self, action: #selector(settingBtnTapped))
        self.settingImageView.addGestureRecognizer(recog)
    }
    
    @objc private func settingBtnTapped() {
        timer.invalidate()
        let alert = UIAlertController(title: "게임 일시정지", message: "왜요?", preferredStyle: .alert)
        let home = UIAlertAction(title: "홈으로", style: .default) { action in
            self.dismiss(animated: true)
        }
        let resume = UIAlertAction(title: "계속하기", style: .cancel) { action in
            self.timerStart()
        }
        let retry = UIAlertAction(title: "다시하기", style: .destructive) { action in
            self.retryGame()
        }
        
        alert.addAction(resume)
        alert.addAction(home)
        alert.addAction(retry)
        present(alert, animated: true)
    }
    
    private func setupCollectionView() {
        gameZoneCollectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = CGFloat(setting!.getItemSpacing())
        flowLayout.minimumInteritemSpacing = CGFloat(setting!.getLineSpacing())
        
        gameZoneCollectionView.dataSource = self
        gameZoneCollectionView.delegate = self
        gameZoneCollectionView.isScrollEnabled = false
        gameZoneCollectionView.backgroundColor = .clear
        gameZoneCollectionView.allowsSelection = false
    }
    
    private func timerStart() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerToLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func timerToLabel() {
        self.gamePlayTime += 1
        self.timeLabel.text = "\(gamePlayTime)"
    }
    
    // 셀 리턴
    private func getCell(index: IndexPath) -> CardCell {
        let cell = self.gameZoneCollectionView.cellForItem(at: index) as! CardCell
        return cell
    }
    
    // 처음 힌트주기
    private func firstHint() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(firstFlip), userInfo: nil, repeats: true)
    }
    
    @objc private func firstFlip() {
        if self.startRow < setting!.getColumn() * setting!.getRow() {
            guard let cell = self.gameZoneCollectionView.cellForItem(at: IndexPath(row: self.startRow, section: 0)) as? CardCell else { return }
            cell.cardToShow(isHint: true)
            self.startRow += 1
        } else {
            // 힌트가 끝나면 액션
            self.timer.invalidate()
            self.timerStart()
            gameZoneCollectionView.allowsSelection = true  // 힌트 시간에는 클릭을 못해 -> 본격 게임 시작 !
            self.startRow = 0
        }
    }
    
    // 게임 클리어시 Alert 및 액션 설정
    private func gameClear() {
//        let recTime = gamePlayTime
//        let count = cardMatchCount
        self.timer.invalidate()
        let alert = UIAlertController(title: "게임 클리어🙌", message: "기록시간 : \(gamePlayTime) / 남은횟수 : \(cardMatchCount)", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
//            let name = alert.textFields![0].text
//            self.saveCoreData(name: name ?? "", time: recTime, life: count)
            self.dismiss(animated: true)
        }
        alert.addTextField { textField in
            textField.placeholder = "이름"
        }
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    // 게임 실패
    private func gameFail() {
        self.timer.invalidate()
        let alert = UIAlertController(title: "🤔게임 실패", message: "아쉬워요", preferredStyle: .alert)
        let home = UIAlertAction(title: "홈으로", style: .default) { action in
//            self.stopBGM()
            self.dismiss(animated: true)
        }
        let retry = UIAlertAction(title: "재도전", style: .default) { action in
            self.retryGame()
        }
        alert.addAction(home)
        alert.addAction(retry)
        present(alert, animated: true)
    }
    
    // 재도전
    private func retryGame() {
        self.setupGameData()
        self.setupCollectionView()
        self.gameZoneCollectionView.reloadData()
        self.firstHint()
    }
    
    public func checkFlipLife() -> Bool {
        if self.cardFlipLife == 0 {
            return false
        } else {
            return true
        }
    }
}

//MARK: - EXTENSION CollectionView
extension GameSceneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.setting!.getRow() * self.setting!.getColumn()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gameZoneCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else { return UICollectionViewCell() }
        cell.index = indexPath
        cell.delegate = self
        cell.cardData = self.cardData[indexPath.row]
        cell.setup()
        return cell
    }
}

extension GameSceneViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (Int(self.gameZoneCollectionView.frame.width) - ((setting!.getRow() - 1) * setting!.getItemSpacing())) / setting!.getRow()
        let height = (Int(self.gameZoneCollectionView.frame.height) - ((setting!.getColumn() - 1) * setting!.getLineSpacing())) / setting!.getColumn()
        
        return CGSize(width: width, height: height)
    }
}

extension GameSceneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.cardData[indexPath.row].id)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        
        // hide 상태라면
        if cell.isShowing == false {
            self.cardFlipLife -= 1
            cell.cardToShow()
        } else {
            print("이미 카드가 뒤집혀 있습니다")
        }
    }
}

extension GameSceneViewController: CardCellDelegate {
    
    // 탭하는 순간, firstItem이 있다면 바로 카운트 중지 !
    func tappedCardPreAni() {
        self.playFlipSound()
        if flipedCard.count != 0 {
            flipedCard[0].cardPairMatched(isSuccessed: false)
        }
    }
    
    func isCardShowed(index: IndexPath) {
        
        // 카드 Flip 라이프가 0이라면, FAIL
        // 1. 셀을 배열에 담아
        // 2. 배열에 담긴 셀이 2개인지 체크
        // 3. 2개라면, 셀을 꺼내 Hide 함수 호출
        let cell = getCell(index: index)
        self.flipedCard.append(cell)
        if flipedCard.count == 2 {
            let first = self.flipedCard[0]
            let second = self.flipedCard[1]
            
            if first.cardData?.id == second.cardData?.id {
                self.cardMatchCount += 1
                self.flipedCard.forEach { cell in
                    cell.cardPairMatched(isSuccessed: true)
                }
            } else {
                first.cardToHide()
                second.cardToHide()
            }
            self.flipedCard = []
        }
        
        if self.cardFlipLife == 0 {
            self.gameFail()
        }
    }
    
    func cardTimeOver() {
        self.flipedCard = []
    }
}
