//
//  HomeViewController.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/21/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // UIButton Outlets
    @IBOutlet weak private var showNotesButton: UIButton!
    @IBOutlet weak private var addNotesButton: UIButton!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        showNotesButton.style()
        addNotesButton.style()
        
        // Hide back button as we don't want to allow user to go back to login screen, unless they logout.
        navigationItem.setHidesBackButton(true, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.HomeVC.navigationTitle
    }
    
    // MARK: Logout
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}
