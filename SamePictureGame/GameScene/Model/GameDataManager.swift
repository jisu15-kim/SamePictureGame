//
//  GameDataManager.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/11.
//

import UIKit

class GameDataManager {
    
//    static public var shared = GameDataManager()

    var cardCount: Int
    var cardData: [GameData] = []
    let colors: [UIColor] = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1 ), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1), #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)]
    
    init(cardCount: Int) {
        self.cardCount = cardCount - 1
    }
    
    func fetchGameData() {
        var datas: [GameData] = []
        let colors = self.colors.shuffled()
        for _ in 0...1 {
            for i in 0...cardCount {
                datas.append(GameData(id: i, image: UIImage(named: "\(i)")!, color: colors[i]))
            }
        }
        let shuffleData = datas.shuffled()
        self.cardData = shuffleData
    }
    
    func getCardData(isShuffle: Bool) -> [GameData] {
        if isShuffle == true {
            fetchGameData()
        }
        return cardData
    }
}
