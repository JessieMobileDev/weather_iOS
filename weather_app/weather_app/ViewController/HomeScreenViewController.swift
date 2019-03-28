//
//  HomeScreenViewController.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func searchTapped(_ sender: UIBarButtonItem) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSearchScreen" {
            
            guard let searchVC = segue.destination as? SearchViewController else { return }
            
            // Values to be passed to the "SearchViewController"
            searchVC.cityName = "Sanford"
            
        } else if segue.identifier == "goToDetailsScreen" {
            
            guard let detailsVC = segue.destination as? DetailsViewController else { return }
            
            // Values to be passed to the "DetailsViewController"
            detailsVC.cityName = "Sanford"
        }
    }
}
