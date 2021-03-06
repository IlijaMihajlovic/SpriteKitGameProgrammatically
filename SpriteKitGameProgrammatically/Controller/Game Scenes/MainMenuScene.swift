//
//  MainMenuScene.swift
//  Sweet Sweets Mania
//
//  Created by Ilija Mihajlovic on 4/18/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import SpriteKit
import UIKit

class MainMenuScene: SKScene {
    
    var background: SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "MainMenuBackground")
        
        sprite.scaleTo(screenWidthPercentage: 1.0)
        sprite.zPosition = 0
        return sprite
    }()
    
    
    lazy var playButton: SSMButton = {
        var button = SSMButton(imageNamed: "ButtonPlay", buttonAction: {
            self.startGameplay()
            
        })
        button.scaleTo(screenWithPercentage: 0.22)
        button.zPosition = 1
        return button
    }()
    
    
    lazy var handleMoreButton: SSMButton = {
        var button = SSMButton(imageNamed: "ButtonSettings", buttonAction: {
            self.handleMore()
            
        })
        button.scaleTo(screenWithPercentage: 0.22)
        button.zPosition = 2
        return button
    }()
    
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.mainMenu = self //Make MainMenuScene Not Nil
        return launcher
    }()
    
    
    
    func handleMore() {
        settingsLauncher.mainMenu = self
        settingsLauncher.showSettings()
        
    }
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButton.position = CGPoint.zero
        setupNodes()
        addNodes()
        
    }
    
    
    @objc func startGameplayNotification(_ info:Notification) {
        startGameplay()
    }
    
    
    func startGameplay() {
        SSMManager.shared.transition(self, toScene: .Gameplay, transition: SKTransition.moveIn(with: .right, duration: 0.5))
        
    }
    
    
    func addNodes() {
        [background, playButton, handleMoreButton].forEach{(addChild($0))}
    }
    
    //MARK: - Constraints
    func setupNodes() {
        background.position = CGPoint.zero
        playButton.position = CGPoint.zero
        
        if DeviceType.isiPhoneX {
            handleMoreButton.position = CGPoint(x: ScreenSize.width * 0.36, y: ScreenSize.heigth * 0.36)
            
        } else {
            handleMoreButton.position = CGPoint(x: ScreenSize.width * 0.34, y: ScreenSize.heigth * 0.35)
        }
        
    }
    
}


