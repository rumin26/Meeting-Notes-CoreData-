//
//  Constants.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/21/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit

/// Caseless Constants enum acts as pure namespace
enum Constants {
    
    static let okButtonTitle = "Ok"
    
    enum LoginVC {
        static let navigationTitle = "Sign In"
        static let invalidAlertTitle = "Invalid Credentials"
        static let emptyFieldsAlertMessage = "Username and Password cannot be empty!"
        static let invalidSignInMessage = "Username and Password does not match!"
    }
    
    enum SignUpVC {
        static let navigationTitle = "Sign Up"
        static let emptyFieldAlertTitle = "Empty Field"
        static let emptyFieldAlertMessage = "%@ cannot be empty!"
    }
    
    enum HomeVC {
        static let navigationTitle = "Welcome"
    }
    
    enum AddNotesVC {
        static let navigationTitle = "Add Notes"
        static let takePicButtonTitle = "Take a Picture"
        static let removePicButtonTitle = "Remove Picture"
        static let invalidAlertTitle = "Empty Note"
        static let emptyFieldsAlertMessage = "Please add title and description of meeting note"
    }
    
    enum SavedNotesVC {
        static let navigationTitle = "Saved Notes"
        static let searchPlaceholder = "Search Meeting Notes"
    }
    
    enum CoreDataEntity {
        static let user = "User"
        static let meeting = "Meeting"
        
        enum User {
            static let name = "name"
            static let address = "address"
            static let email = "email"
            static let phone = "phone"
            static let username = "username"
            static let password = "password"
        }
        
        enum Meeting {
            static let title = "title"
            static let description = "desc"
            static let image = "image"
            static let date = "date"
        }
    }
}
