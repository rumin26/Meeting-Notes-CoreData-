//
//  NotesTableViewCell.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewCell: UITableViewCell {
    
    /// Cell Identifier
    static let cellIdentifier = "noteTableCell"

    // UILabel Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    // UIImageView Outlet
    @IBOutlet weak private var noteImageView: UIImageView!

    func configureCell(_ object: NSManagedObject) {
        titleLabel.text = object.value(forKeyPath: Constants.CoreDataEntity.Meeting.title) as? String
        descriptionLabel.text = object.value(forKeyPath: Constants.CoreDataEntity.Meeting.description) as? String
        noteImageView.image = object.value(forKeyPath: Constants.CoreDataEntity.Meeting.image) as? UIImage
        dateLabel.text = object.value(forKeyPath: Constants.CoreDataEntity.Meeting.date) as? String
    }
}
