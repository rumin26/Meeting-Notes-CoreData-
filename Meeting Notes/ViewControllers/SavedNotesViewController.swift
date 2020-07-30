//
//  SavedNotesViewController.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import UIKit
import CoreData

class SavedNotesViewController: UIViewController {

    //UITableView Outlet
    @IBOutlet weak private var notesTableView: UITableView!
    
    // Private Instance Variables
    private let searchController = UISearchController(searchResultsController: nil)
    private var meetingNotesArray: [NSManagedObject] = []
    private var filteredNotesArray: [NSManagedObject] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove Back button title
        navigationController?.navigationBar.topItem?.title = ""
        
        // Configure Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.SavedNotesVC.searchPlaceholder
        navigationItem.hidesSearchBarWhenScrolling = false // Always show search bar
        navigationItem.searchController = searchController
        definesPresentationContext = true // Search bar doesn't remain on screen when user leaves the screen
        
        // Configure table view
        notesTableView.rowHeight = UITableView.automaticDimension
        notesTableView.estimatedRowHeight = 145
        notesTableView.tableFooterView = UIView()
        
        registerTableViewCell()
        fetchMeetingNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.SavedNotesVC.navigationTitle
    }
    
    // MARK: Logout
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Helper Methods
    
    /// Method to register custom table view cell
    private func registerTableViewCell() {
        let noteTableViewCell = UINib(nibName: String(describing: NotesTableViewCell.self), bundle: nil)
        notesTableView.register(noteTableViewCell, forCellReuseIdentifier: NotesTableViewCell.cellIdentifier)
    }
    
    /// Method to fetch meeting notes from Core Data
    private func fetchMeetingNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Create a new managed object context to save data in Core Data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Meeting.createFetchRequest()
        
        do {
            meetingNotesArray = try managedContext.fetch(fetchRequest)
            notesTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func filterNotes(with searchText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Create a new managed object context to fetch data from Core Data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Meeting.createFetchRequest()
        
        // Filter result based on search text
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@ OR desc CONTAINS[c] %@ OR date CONTAINS[c] %@", searchText,
                                             searchText, searchText)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            filteredNotesArray = try managedContext.fetch(fetchRequest)
            notesTableView.reloadData()
        } catch let error as NSError {
            // Print error if any while fetching from core data
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension SavedNotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotesArray.count
        }
        
        return meetingNotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let noteCell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.cellIdentifier,
                                                           for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        let note: NSManagedObject
        
        if isFiltering {
            note = filteredNotesArray[indexPath.row]
        } else {
            note = meetingNotesArray[indexPath.row]
        }
        
        noteCell.configureCell(note)
        noteCell.layoutIfNeeded() // Update cell constraints to its content if required
        
        return noteCell
    }
}

extension SavedNotesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterNotes(with: searchBar.text!)
    }
}
