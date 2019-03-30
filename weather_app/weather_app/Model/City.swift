//
//  City.swift
//  weather_app
//
//  Created by Jessica on 3/30/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import Foundation

class City {
    
    // Variables
    let cityName: String?
    let estateName: String?
    let countryName: String?
    
    init(cityName: String, estateName: String, countryName: String) {
        self.cityName = cityName
        self.estateName = estateName
        self.countryName = countryName
    }
}
