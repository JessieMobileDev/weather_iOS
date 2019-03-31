//
//  HomeScreenViewController.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Variables
    var cityName = ""
    var bookmarkedCities: [String] = []
    let USER_DEFAULT_CITIES_BOOKMARK: String = "USER_DEFAULT_CITIES_BOOKMARK"
    let defaults = UserDefaults.standard
    
    // Outlets
    @IBOutlet weak var tableView_bookmarks: UITableView!
    @IBOutlet weak var imageView_emptyState: UIImageView!
    @IBOutlet weak var label_emptyState_title: UILabel!
    @IBOutlet weak var label_emptyState_description: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the delegates
        tableView_bookmarks.delegate = self
        tableView_bookmarks.dataSource = self
        
        // Remove excess empty cells and add same padding for right and left side of the cell divider
        tableView_bookmarks.tableFooterView = UIView()
        tableView_bookmarks.separatorInset = .init(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        // Empty state is shown if there are no elements in the bookmarkedCities array
        bookmarkedCities = loadArrayFromUserDefaults()
        tableView_bookmarks.reloadData()
        updateEmptyState()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCell else { return tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)}
        
        let cityCell = bookmarkedCities[indexPath.row].description
        
        cell.label_cityName.text = cityCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Remove the item from the array
        bookmarkedCities.remove(at: indexPath.row)
        
        // Update userdefaults
        defaults.set(bookmarkedCities, forKey: USER_DEFAULT_CITIES_BOOKMARK)
        
        // Update the table view with new data
        tableView_bookmarks.reloadData()
        updateEmptyState()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ConnectionHandler.Connection() {
            
           performSegue(withIdentifier: "goToDetailsScreen", sender: indexPath)
        } else {
            
            showAlert(title: "No connection", message: "Turn on the connection on your phone to proceed", positiveBtn: "OK")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMapScreen" {
            
            if ConnectionHandler.Connection() {
                
                guard let _ = segue.destination as? MapViewController else { return }
            } else {
                
                showAlert(title: "No connection", message: "Turn on the connection on your phone to proceed", positiveBtn: "OK")
            }
            
        } else if segue.identifier == "goToDetailsScreen" {
            
            guard let detailsVC = segue.destination as? DetailsViewController else { return }
            let rowValue = bookmarkedCities[(sender as! NSIndexPath).row]
            detailsVC.cityName = rowValue
        }
    }
    
    @IBAction func unwindToHomeScreen(_ unwindSegue: UIStoryboardSegue) {
        
        guard let sourceViewController = unwindSegue.source as? MapViewController else { return }
        self.cityName = sourceViewController.cityName
        
        // Check if the selected city is already in the array
        if !bookmarkedCities.contains(sourceViewController.cityName) {
            self.bookmarkedCities.append(sourceViewController.cityName)
        }
        
        // Update userdefaults
        saveArrayToUserDefaults(bookmarks: bookmarkedCities)
        
        // Update the table view with new data
        tableView_bookmarks.reloadData()
        updateEmptyState()
    }
}

extension HomeScreenViewController {
    
    func updateEmptyState() {
        
        if bookmarkedCities.count == 0 {
            
            // Display the empty state if no data
            imageView_emptyState.isHidden = false
            label_emptyState_title.isHidden = false
            label_emptyState_description.isHidden = false
        } else {
            
            // Hide the empty state if there is data
            imageView_emptyState.isHidden = true
            label_emptyState_title.isHidden = true
            label_emptyState_description.isHidden = true
        }
    }
    
    func saveArrayToUserDefaults(bookmarks: [String]) {
        
        defaults.set(bookmarks, forKey: USER_DEFAULT_CITIES_BOOKMARK)
    }
    
    func loadArrayFromUserDefaults() -> [String] {
        
        return defaults.stringArray(forKey: USER_DEFAULT_CITIES_BOOKMARK) ?? [String]()
    }
    
    func showAlert(title: String, message: String, positiveBtn: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: positiveBtn, style: UIAlertAction.Style.default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
