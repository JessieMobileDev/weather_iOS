//
//  SearchViewController.swift
//  weather_app
//
//  Created by Jessica on 3/28/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // Variables
    var cityName: String!
    var cityWeatherUrl1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    var cityWeatherUrl2: String = "&appid=07d507ff7042b77082e11242514fb182&units=imperial"
//    var weatherList: [Weather]()
    
    // Outlets
//    @IBOutlet weak var tableView_search: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Set up the search bar delegate
//        searchBar.delegate = self
//
//        // Set up the table view delegate
//        tableView_search.delegate = self
//        tableView_search.dataSource = self
    }
    
    // When enter was pressed, the following code triggers
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text
        if searchText != nil && searchText != "" {
            
            let weatherUrl = cityWeatherUrl1 + searchText! + cityWeatherUrl2
            
            print(weatherUrl)
            retrieveWeatherJSONData(weatherUrl: weatherUrl)
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
//        cell.label_cityName.text = "Sanford"
        
        return cell
    }
    
    func retrieveWeatherJSONData(weatherUrl: String) {
        
        guard let url = URL(string: weatherUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {

                    self.parseJSONData(jsonData: jsonData)
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

        // Retrieving: icon
        guard let results_icon = jsonData["weather"] as? [[String: Any]],
            let results_icon_firstObject = results_icon[0] as? [String: Any],
            let icon = results_icon_firstObject["icon"] as? String
            else { return }

        // Retrieving: Wind speed
        guard let results_wind = jsonData["wind"] as? [String: Any],
            let speed = results_wind["speed"] as? Double
            else { return }

//        // Retrieving: rain chance
//        guard let results_rain = jsonData["rain"] as? [String: Any],
//            let rainChance = results_rain["3h"] as? Double
//            else { return }
        
        // Retrieving: rain chance (Some cities will not have the rain key
        var rainChance: Double = 0.0
        if let results_rain = jsonData["rain"] as? [String: Any] {
            
            rainChance = results_rain["3h"] as! Double
        }
//        let currentTemperature: Double?
//        let humidity: Int?
//        let rainChance: Double?
//        let windSpeed: Double?
//        let latitude: Double?
//        let longitude: Double?
//        let icon: String?

        let weather: Weather = Weather(currentTemp: temperature, humidity: humidity, rainChance: rainChance, windSpeed: speed, latitude: lat, longitude: lon, icon: icon)
        
        print("Temperature: \(temperature) -- Humidity: \(humidity) -- Rain: \(rainChance) -- Icon: \(icon) -- Latitude: \(lat) -- Longitude: \(lon) -- Wind Speed: \(speed)")
        
    }
}
