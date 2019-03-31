//
//  Weather.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import Foundation

class Weather: Decodable {
    
    // Variables
    let currentTemperature: Double?
    let humidity: Double?
    let rainChance: Double?
    let windSpeed: Double?
    let latitude: Double?
    let longitude: Double?

    init(currentTemp: Double, humidity: Double, rainChance: Double, windSpeed: Double, latitude: Double, longitude: Double) {
        self.currentTemperature = currentTemp
        self.humidity = humidity
        self.rainChance = rainChance
        self.windSpeed = windSpeed
        self.latitude = latitude
        self.longitude = longitude
    }
}
