//
//  MobImage.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/16.
//

import UIKit

class MobImage: UIImageView {
    var rotationToggle = true
    var timer = Timer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#function)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#function)
        loadView()
    }
    
    func loadView() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(rotateImage), userInfo: nil, repeats: true)
    }
    
    @objc func rotateImage() {
        
        if rotationToggle == true {
            self.transform = CGAffineTransform(rotationAngle: 0.1)
            
        } else {
            self.transform = CGAffineTransform(rotationAngle: -0.1)
        }
        rotationToggle.toggle()
    }

}
