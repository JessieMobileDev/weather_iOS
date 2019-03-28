//
//  Weather.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import Foundation

class Weather {
    
    // Variables
    let currentTemperature: String
    let humidity: String
    let rainChance: String
    let windInformation: String
    
    init(currentTemp: String, humidity: String, rainChance: String, windInfo: String) {
        self.currentTemperature = currentTemp
        self.humidity = humidity
        self.rainChance = rainChance
        self.windInformation = windInfo
    }
}
