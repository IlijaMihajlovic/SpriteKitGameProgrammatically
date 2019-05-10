//
//  UserProfileController.swift
//  SpriteKitGameProgrammatically
//
//  Created by Ilija Mihajlovic on 5/5/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import SpriteKit
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import LBTAComponents
import SVProgressHUD


class UserProfileScene: SKScene {
    
    let userProfileImageViewHeight: CGFloat = 80
    
    lazy var userProfileImage: CachedImageView = {
        var image = CachedImageView()
        
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .customLightPinkColor
        image.layer.cornerRadius = userProfileImageViewHeight / 2
        image.layer.masksToBounds = false
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var fetchUserButton: BDButton = {
        var button = BDButton(imageNamed: "FetchUser", buttonAction: {
            
            self.fetchUserButtonTapped()
            
        })
        button.scaleTo(screenWithPercentage: 0.7)
        button.zPosition = 1
        return button
    }()
    
    lazy var signOutAnonymouslyButton: BDButton = {
        var button = BDButton(imageNamed: "SignOut", buttonAction: {
            
            self.handleSignOutButtonTapped()
            
        })
        button.scaleTo(screenWithPercentage: 0.3)
        button.zPosition = 1
        return button
    }()
    
    lazy var backButton: BDButton = {
        var button = BDButton(imageNamed: "BackToMainMenu", buttonAction: {
            
            self.userProfileImage.removeFromSuperview()
            ACTManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.moveIn(with: .left, duration: 0.1))
            self.userProfileImage.removeFromSuperview()
            
        })
        button.scaleTo(screenWithPercentage: 0.3)
        button.zPosition = 2
        return button
    }()
    
    var nameLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        label.fontSize = 19
        label.text = "User's Name"
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 310
        label.fontColor = SKColor.lightGray
        label.zPosition = 3
        
        return label
    }()
    
    var emailLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        label.fontSize = 15
        label.text = "User's Email"
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 310
        label.fontColor = SKColor.lightGray
        label.zPosition = 3
        
        return label
    }()
    
    
     func fetchUserButtonTapped() {
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show(withStatus: "Fetching User...")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dict = snapshot.value as? [String: Any] else { return }
                
                //Create User
                let user = CurrentUser(dictionary: dict)
                
                self.nameLabel.text = user.name
                self.emailLabel.text = user.email
                
                //Load image from Firebase and assign it
                self.userProfileImage.loadImage(urlString: user.profileImageUrl)
                SVProgressHUD.dismiss()
                
            }) { (error) in
                print(error)
                SVProgressHUD.showError(withStatus: "Can't Fetch User\n \(error)")
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scene?.backgroundColor = .white
        
        addNodes()
        setupNodes()
        
        print("In UserProfileController")
    }
    
    
    //Check if the user is Siggned Up
    fileprivate func handleSignOutButtonTapped() {
        
        let errorAction = UIAlertAction(title: "Sign Out Error", style: .default, handler: nil)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            
            do {
                try Auth.auth().signOut()
                
                self.userProfileImage.removeFromSuperview()
                ACTManager.shared.transition(self, toScene: .WelcomeScene, transition: SKTransition.moveIn(with: .left, duration: 0.1))
                
            } catch let err {
                print("Failed to sign out with error", err)
                
                ACTManager.shared.showAlert(on: self, title: "Sign Out Error", message: err.localizedDescription, actions: [errorAction], animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ACTManager.shared.showAlert(on: self, title: "Are You Sure?", message: "You Will Sign Out From The Biggest Logo", actions: [cancelAction, signOutAction])
        
    }
    
    
    func addNodes() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.view?.addSubview(self.userProfileImage)
        }
        
        [signOutAnonymouslyButton, backButton, fetchUserButton, nameLabel, emailLabel].forEach{addChild($0)}
    }
    
    func setupNodes() {
        
        signOutAnonymouslyButton.position = CGPoint(x: ScreenSize.width * 0.31, y: ScreenSize.heigth * 0.40)
        backButton.position = CGPoint(x: ScreenSize.width * -0.29, y: ScreenSize.heigth * 0.40)
        fetchUserButton.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * -0.42)
        nameLabel.position = CGPoint(x: ScreenSize.width * 0.0, y: ScreenSize.heigth * 0.11)
        emailLabel.position = CGPoint(x: (ScreenSize.width * 0.0), y: (ScreenSize.heigth * 0.10) - 30)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        
        self.userProfileImage.anchor(top: self.view?.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, padding: .init(top: 110, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        self.userProfileImage.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
        
        }
        
    }
    
}




