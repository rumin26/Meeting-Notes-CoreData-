//
//  LoginViewController.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/21/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    // UITextField Outlets
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    // UIButton Outlets
    @IBOutlet weak private var signInButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.style()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.LoginVC.navigationTitle
    }
    
    // MARK: Sign In
    @IBAction func signInPressed(_ sender: UIButton) {
        signInUser()
    }
    
    // MARK: Helper Methods
    
    /// Method to sign in user in app
    private func signInUser() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Create a new managed object context to fetch data from Core Data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for login
        let request = User.createFetchRequest()
        request.predicate = NSPredicate(format: "username = %@ AND password = %@", username, password)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            
            if !result.isEmpty {
                performSegue(withIdentifier: "signIn", sender: nil)
            } else {
                let inValidAlert = UIAlertController(title: Constants.LoginVC.invalidAlertTitle,
                                                             message: Constants.LoginVC.invalidSignInMessage,
                                                             preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default)
                inValidAlert.addAction(okAction)
                inValidAlert.view.tintColor = Colors.greenTint
                present(inValidAlert, animated: true)
            }
        } catch let error as NSError {
            // Print error if any while fetching from core data
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
