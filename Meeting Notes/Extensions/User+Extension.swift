//
//  User+Extension.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

extension User {
    
    class func createFetchRequest() -> NSFetchRequest<NSManagedObject> {
        // Create a fetch request for User
        let request = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreDataEntity.user)
        return request
    }
}
