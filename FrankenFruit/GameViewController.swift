//
//  GameViewController.swift
//  FrankenFruit
//
//  Created by Jonah Kornberg on 3/15/19.
//  Copyright © 2019 Jonah Kornberg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        let scene = GameScene(size: CGSize(width: 812, height: 375))
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        let skView = view as! SKView
        scene.backgroundColor = UIColor.red
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
        print("Screen Size: \(UIScreen.main.bounds.width) x \(UIScreen.main.bounds.height)")
        print("Scene Size: \(scene.size.width) x \(scene.size.height)")
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
