//
//  SignUpViewController.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/21/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    // UITextField Outlets
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    // UIScrollView Outlet
    @IBOutlet weak private var scrollView: UIScrollView!
    
    // UIButton Outlets
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove Back button title
        navigationController?.navigationBar.topItem?.title = ""
        
        hideKeyboard()
        signUpButton.style()
        
        // Keyboard handling when tapped on textfield
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.SignUpVC.navigationTitle
    }
    
    // MARK: Sign Up
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard isValidatedTextField() else {
            return
        }
        
        signUpUser()
    }
    
    // MARK: Helper Methods
    
    /// Method to adjust scroll view when keyboard is shown
    /// - Parameter notification: UIResponder.keyboardWillShowNotification
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    /// Method to adjust scroll view when keyboard is hidden
    /// - Parameter notification: UIResponder.keyboardWillHideNotification
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = .zero
            self.scrollView.contentOffset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    /// Method to check if any of the field is empty
    /// - Returns: boolean
    private func isValidatedTextField() -> Bool {
        guard !(nameTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Name")
            return false
        }
            
        guard !(addressTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Address")
            return false
        }
        
        guard !(emailTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Email")
            return false
        }
        
        guard !(phoneTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Phone")
            return false
        }
        
        guard !(usernameTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Username")
            return false
        }
        
        guard !(passwordTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert("Password")
            return false
        }
        
        return true
    }
    
    /// Method to show alert if any of the sign up field is empty
    /// - Parameter type: type of message to be shown
    private func showMandatoryFieldAlert(_ type: String) {
        let mandatoryFieldsAlert = UIAlertController(title: Constants.SignUpVC.emptyFieldAlertTitle,
                                                     message: String(format: Constants.SignUpVC.emptyFieldAlertMessage, type),
                                                     preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default)
        mandatoryFieldsAlert.addAction(okAction)
        mandatoryFieldsAlert.view.tintColor = Colors.greenTint
        present(mandatoryFieldsAlert, animated: true)
    }
    
    /// Method to save user data in Core Data
    private func signUpUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Create a new managed object context to save data in Core Data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a new managed object and insert it into the managed object context
        let userEntity = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntity.user, in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        // Setup user data to save
        user.setValue(nameTextField.text, forKeyPath: Constants.CoreDataEntity.User.name)
        user.setValue(emailTextField.text, forKeyPath: Constants.CoreDataEntity.User.email)
        user.setValue(addressTextField.text, forKeyPath: Constants.CoreDataEntity.User.address)
        user.setValue(phoneTextField.text, forKeyPath: Constants.CoreDataEntity.User.phone)
        user.setValue(usernameTextField.text, forKeyPath: Constants.CoreDataEntity.User.username)
        user.setValue(passwordTextField.text, forKeyPath: Constants.CoreDataEntity.User.password)
        
        do {
            // Commit changes into core data user model
            try managedContext.save()
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            // Print error if any while saving data
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
