//
//  AddNotesViewController.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

class AddNotesViewController: UIViewController {
    
    /// Enum for mage Picker Source
    enum ImageSource {
        case photoLibrary
        case camera
    }

    // UITextField Outlet
    @IBOutlet weak private var titleTextField: UITextField!
    
    // UITextView Outlet
    @IBOutlet weak private var descriptionTextView: UITextView!
    
    // UIButton Outlet
    @IBOutlet weak private var takePicButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    
    // UIImageView Outlet
    @IBOutlet weak private var notesImageView: UIImageView!
    
    // Private Instance Variables
    private var imagePicker: UIImagePickerController!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove Back button title
        navigationController?.navigationBar.topItem?.title = ""
        
        saveButton.style()
        hideKeyboard()
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.AddNotesVC.navigationTitle
    }
    
    // MARK: Take Picture
    @IBAction func takePicPressed(_ sender: UIButton) {
        if let _ = notesImageView.image {
            UIView.animate(withDuration: 0.5) {
                self.notesImageView.image = nil
                self.notesImageView.isHidden = true
            }

            takePicButton.setTitle(Constants.AddNotesVC.takePicButtonTitle, for: .normal)
        } else {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                chooseImageFrom(.photoLibrary)
                return
            }
            
            chooseImageFrom(.camera)
        }
    }
    
    // MARK: Save
    @IBAction func savePressed(_ sender: UIButton) {
        guard isValidatedFields() else {
            return
        }
        
        saveMeetingNotes()
    }
    
    // MARK: Logout
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Helper Methods
    
    /// Method to check if any of the field is empty
    /// - Returns: boolean
    private func isValidatedFields() -> Bool {
        guard !(titleTextField.text ?? "").isEmpty else {
            showMandatoryFieldAlert()
            return false
        }
            
        guard !(descriptionTextView.text ?? "").isEmpty else {
            showMandatoryFieldAlert()
            return false
        }
        
        return true
    }
    
    /// Method to show alert if any of the field is empty while adding notes
    /// - Parameter type: type of message to be shown
    private func showMandatoryFieldAlert() {
        let mandatoryFieldsAlert = UIAlertController(title: Constants.AddNotesVC.invalidAlertTitle,
                                                     message: Constants.AddNotesVC.emptyFieldsAlertMessage,
                                                     preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .default)
        mandatoryFieldsAlert.addAction(okAction)
        mandatoryFieldsAlert.view.tintColor = Colors.greenTint
        present(mandatoryFieldsAlert, animated: true)
    }
    
    /// Method to choose image from image picker
    /// - Parameter source: ImageSource enum type (Example: Camera)
    private func chooseImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    /// Method to save meeting notes in Core Data
    private func saveMeetingNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Create a new managed object context to save data in Core Data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a new managed object and insert it into the managed object context
        let meetingEntity = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntity.meeting, in: managedContext)!
        let meeting = NSManagedObject(entity: meetingEntity, insertInto: managedContext)
        
        // Setup user data to save
        meeting.setValue(titleTextField.text, forKeyPath: Constants.CoreDataEntity.Meeting.title)
        meeting.setValue(descriptionTextView.text, forKeyPath: Constants.CoreDataEntity.Meeting.description)
        meeting.setValue(notesImageView.image, forKeyPath: Constants.CoreDataEntity.Meeting.image)
        meeting.setValue(Date().customDate, forKeyPath: Constants.CoreDataEntity.Meeting.date)
        
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

extension AddNotesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        notesImageView.image = selectedImage
        notesImageView.isHidden = false
        
        takePicButton.setTitle(Constants.AddNotesVC.removePicButtonTitle, for: .normal)
    }
}

extension AddNotesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
