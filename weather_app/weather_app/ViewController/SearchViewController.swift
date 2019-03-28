//
//  SearchViewController.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // Variables
    var cityName: String!
    var cityWeatherUrl1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    var cityWeatherUrl2: String = "&appid=07d507ff7042b77082e11242514fb182&units=imperial"
//    var weatherList: [Weather]()
    
    // Outlets
    @IBOutlet weak var tableView_search: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the search bar delegate
        searchBar.delegate = self
        
        // Set up the table view delegate
        tableView_search.delegate = self
        tableView_search.dataSource = self
    }
    
    // When enter was pressed, the following code triggers
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text
        if searchText != nil && searchText != "" {
            
            let weatherUrl = cityWeatherUrl1 + searchText! + cityWeatherUrl2
            
            print(weatherUrl)
        } else {
            
            // Display an error, search field cannot be empty
            let alert = UIAlertController(title: "Empty Field", message: "Please, type in a city name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else { return tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)}
        
        // TODO: Change how it's displayed
        cell.label_cityName.text = "Sanford"
        
        return cell
    }
}
