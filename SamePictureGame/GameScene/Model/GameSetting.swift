//
//  GameHelper.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/11.
//

import Foundation

struct GameSetting {
    
    //MARK: - 싱글톤
//    public static var shared = GameSetting()
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    //MARK: - 게임 세팅값
    
    // 가로
    private let row: Int
    // 세로
    private let column: Int
    private let cardFlipTime: Float = 1.0

    private let itemSpacing = 10
    private let lineSpacing = 10
    
    // 카드 뒤집기 횟수
    public func getLifeCount() -> Int {
        let count = Int(Float(self.row * self.column) * 2)
        return count
    }
    
    // 개별 카드 뒤집히는 시간
    public func getCardFlipTime() -> Float {
        return self.cardFlipTime
    }
    
    // 가로 갯수
    public func getRow() -> Int {
        return self.row
    }
    
    // 세로 갯수
    public func getColumn() -> Int {
        return self.column
    }
    
    public func getItemSpacing() -> Int {
        return itemSpacing
    }
    
    public func getLineSpacing() -> Int {
        return lineSpacing
    }
}
