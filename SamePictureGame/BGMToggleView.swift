//
//  BGMToggleView.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/15.
//

import UIKit

class BGMToggleView: UIView {
    
    var delegate: BGMToggleViewDelegate?
    var subVC: UIViewController?
    
    let muteImage = UIImage(systemName: "speaker.slash.fill")
    let unmuteImage = UIImage(systemName: "speaker.wave.2.fill")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var bgmToggleView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
    
    private func loadView() {

        self.addSubview(bgmToggleView)
        self.setupConstraints()
        self.bgmToggleView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.soundToggle(_:)))
        self.bgmToggleView.addGestureRecognizer(gesture)
        fetchImage()
        bgmToggleView.tintColor = .white
    }
    
    private func fetchImage() {
        if appDelegate.isPlayEnabled == true {
            bgmToggleView.image = muteImage
        } else {
            bgmToggleView.image = unmuteImage
        }
    }
    
    @objc public func soundToggle(_ sender: UITapGestureRecognizer) {
        if appDelegate.isPlayEnabled == true {
            self.bgmToggleView.image = unmuteImage
        } else {
            self.bgmToggleView.image = muteImage
        }
        appDelegate.musicToggle()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            bgmToggleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgmToggleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgmToggleView.topAnchor.constraint(equalTo: self.topAnchor),
            bgmToggleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
