//
//  CardCell.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/11.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    var isShowing = false
    var cardData: GameData?
    
    var index: IndexPath?
    
    var delegate: CardCellDelegate?
    
    var cardImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timer: Timer = Timer()
    
    var timeCount: Int = 0 {
        didSet {
            if timeCount < 0 {
                countLabel.text = ""
            } else {
                countLabel.text = "\(timeCount)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup() {

        self.addSubview(cardImage)
        self.addSubview(countLabel)
        setupConstraints()
        cardImageInit()
        setupUI()
    }
    
    // 카드 보여주기
    public func cardToShow(isHint: Bool? = false) {
        if let data = cardData {
            self.delegate?.tappedCardPreAni()
            self.isShowing = true
            self.cardImage.image = data.image
            self.cardImage.backgroundColor = data.color
            self.cardImage.contentMode = .scaleAspectFit
            UIView.transition(with: cardImage, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { _ in
                if isHint == true {
                    self.cardToHide()
                } else {
                    self.timeCount = 2
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showedCardTimer), userInfo: nil, repeats: true)
                    self.delegate?.isCardShowed(index: self.index!)
                }
            }
        }
    }
    
    @objc private func showedCardTimer() {
        
        if self.timeCount == 0 {
            cardToHide()
            delegate?.cardTimeOver()
            self.timer.invalidate()
        }
        print(timeCount)
        self.timeCount -= 1
    }
    
    // 카드 이미지 초기 설정
    private func cardImageInit() {
        self.isShowing = false
        self.cardImage.image = UIImage(named: "back")
        self.cardImage.backgroundColor = .label
        self.cardImage.contentMode = .scaleAspectFill
    }
    
    private func firstHint() {
        self.cardToShow(isHint: true)
    }
    
    public func cardPairMatched(isSuccessed: Bool) {
        self.timer.invalidate()
        if isSuccessed == true {
            self.countLabel.text = ""
        }
    }
    
    // 카드 가리기
    public func cardToHide(isHint: Bool = false) {
        self.countLabel.text = ""
        self.isShowing = false
        self.cardImage.image = UIImage(named: "back")
        self.cardImage.backgroundColor = .label
        self.cardImage.contentMode = .scaleAspectFill
        UIView.transition(with: cardImage, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { _ in
            if self.timer.isValid == true {
                self.timer.invalidate()
            }
        }
    }
    
    private func setupUI() {
        cardImage.layer.cornerRadius = 10
        cardImage.clipsToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardImage.topAnchor.constraint(equalTo: self.topAnchor),
            cardImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            countLabel.topAnchor.constraint(equalTo: self.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
