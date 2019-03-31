//
//  DetailsViewController.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // Variables
    var cityName: String!
    var cityWeatherUrl1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    var cityWeatherUrl2: String = "&appid=07d507ff7042b77082e11242514fb182&units=imperial"
    
    // Outlets
    @IBOutlet weak var label_temperature: UILabel!
    @IBOutlet weak var label_cityName: UILabel!
    @IBOutlet weak var label_rain: UILabel!
    @IBOutlet weak var label_humidity: UILabel!
    @IBOutlet weak var label_wind: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Value passed to details: " + cityName)
        
        activityIndicator.isHidden = false
        
        retrieveWeatherJSONData(weatherUrl: cityWeatherUrl1 + cityName.split(separator: " ").joined(separator: "+") + cityWeatherUrl2)
    }
}

extension DetailsViewController {
    
    func retrieveWeatherJSONData(weatherUrl: String) {
        
        print("Before url check")
        guard let url = URL(string: weatherUrl) else { return }
        print("after url check")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            print("before checking data")
            guard let data = data else { return }
            
            print("before do")
            do {
                
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    self.parseJSONData(jsonData: jsonData)
                } else {
                    
                    print("uh-oh")
                }
                
            } catch {
                
                print("Error serializing JSON: ", error)
            }
            
            }.resume()
    }
    
    func parseJSONData(jsonData: [String: Any]) {
        
        // Retrieving: temperature, humidity
        guard let results_main = jsonData["main"] as? [String: Any],
            let temperature = results_main["temp"] as? Double,
            let humidity = results_main["humidity"] as? Double
            else { return }
        
        // Retrieving: Latitude and longitude
        guard let results_coords = jsonData["coord"] as? [String: Any],
            let lat = results_coords["lat"] as? Double,
            let lon = results_coords["lon"] as? Double
            else { return }
        
        // Retrieving: Wind speed
        guard let results_wind = jsonData["wind"] as? [String: Any],
            let speed = results_wind["speed"] as? Double
            else { return }
        
        // Retrieving: rain chance (Some cities will not have the rain key
        var rainChance: Double = 0.0
        if let results_rain = jsonData["rain"] as? [String: Any] {
            
            rainChance = results_rain["3h"] as! Double
        }
        
        let weather: Weather = Weather(currentTemp: temperature, humidity: humidity, rainChance: rainChance, windSpeed: speed, latitude: lat, longitude: lon)
        
        DispatchQueue.main.async {
            
            // Update the UI
            self.label_temperature.text = (weather.currentTemperature?.description ?? "") + "F"
            self.label_cityName.text = self.cityName ?? ""
            self.label_rain.text = "Rain\n" + (weather.rainChance?.description ?? "") + "%"
            self.label_humidity.text = "Humidity\n" + (weather.humidity?.description ?? "") + "%"
            self.label_wind.text = "Wind\n" + (weather.windSpeed?.description ?? "") + " mph"
            
            self.updateActivityIndicator()
        }
    }
    
    func updateActivityIndicator() {
        
        if activityIndicator.isHidden == false {
            
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}
