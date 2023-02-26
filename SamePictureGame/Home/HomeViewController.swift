//
//  ViewController.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/11.
//

import UIKit

class HomeViewController: UIViewController, GameSceneDelegate {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var easyStartButton: UIButton!
    @IBOutlet weak var hardStartButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    
    var bgmToggleView: BGMToggleView = {
        let view = BGMToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func gameSceneDismiss() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewToRoundCorner(view: self.titleView)
        viewToRoundCorner(view: self.easyStartButton)
        viewToRoundCorner(view: self.hardStartButton)
        viewToRoundCorner(view: self.rankingButton)
        setupBgmToggleView()
        appDelegate.playMusic()
    }
    
    func viewToRoundCorner(view: UIView) {
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
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

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "EASY 게임 시작" {
            let setting = GameSetting(row: 4, column: 3)
            let vc = loadGameVC(setting: setting)
            present(vc, animated: true)
        } else {
            let setting = GameSetting(row: 5, column: 4)
            let vc = loadGameVC(setting: setting)
            present(vc, animated: true)
        }
    }
    
    private func loadGameVC(setting: GameSetting) -> GameSceneViewController {
        let story = UIStoryboard(name: "GameScene", bundle: nil)
        guard let vc = story.instantiateViewController(withIdentifier: "GameSceneViewController") as? GameSceneViewController else { return GameSceneViewController() }
        vc.modalPresentationStyle = .fullScreen
        vc.setting = setting
        vc.delegate = self
        return vc
    }
    
    @IBAction func rankButtonTapped(_ sender: UIButton) {
        
    }
}

extension HomeViewController: BGMToggleViewDelegate {
    func BgmViewTapped() {
        print(#function)
        appDelegate.musicToggle()
    }
}

