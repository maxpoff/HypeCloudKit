//
//  SignUpViewController.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/6/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        UserController.sharedInstance.createUserWith(username: username) { (result) in
            switch result {
            case .success(let newUser):
                UserController.sharedInstance.currentUser = newUser
                self.presentHypeListVC()
                
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    //MARK: - Class Methods
    func fetchUser() {
        UserController.sharedInstance.fetchUser { (result) in
            
            switch result {
            case .success(let currentUser):
                UserController.sharedInstance.currentUser = currentUser
                self.presentHypeListVC()
                
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}//End of class
