//
//  WeatherData.swift
//  SingaporeWeather
//
//  Created by Ammar Rusydi on 12/01/2018.
//  Copyright © 2018 Ammar. All rights reserved.
//

import Foundation
import SVProgressHUD

// JSON Parsing using Decodable swift 4

// Values to use:
// city, country, condition date, condition temp, condition text, forecast date, forecast low, forecast high, forecast text

struct getWeather {
    var city : String? = ""
    var country : String? = ""
    var date : String? = ""
    var temp : String? = ""
    var text : String? = ""
    var forecast : [Forecast]? = []
}

struct WeatherData: Decodable {
    let query: Query
}

struct Query: Decodable {
    let count: Int?
    let created: String?
    let lang: String?
    let results : Result
}

struct Result: Decodable {
    let channel : Channel
}

struct Channel: Decodable {
    let location : Location
    let item : Item
}

struct Location: Decodable {
    var city : String?
    var country : String?
    let region: String?
}

struct Item: Decodable {
    let condition : Condition
    let forecast : [Forecast]
}

struct Condition: Decodable {
    let date: String?
    let temp: String?
    let text: String?
}

struct Forecast: Decodable {
    var date: String?
    var low: String?
    var high: String?
    var text: String?
    var day : String?
}

public class WeatherObject {
    
    var arrayWeatherData : [getWeather] = []
    
    init() {
        guard let url = URL(string: ServerRequest.query()) else { return }
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            
                guard let data = data else { return }
                
                do {
                    var dataForecast : getWeather = getWeather()
                    let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                    
                    dataForecast.city = weather.query.results.channel.location.city
                    dataForecast.country = weather.query.results.channel.location.country
                    dataForecast.temp = weather.query.results.channel.item.condition.temp
                    dataForecast.date = weather.query.results.channel.item.condition.date
                    dataForecast.text = weather.query.results.channel.item.condition.text
                    dataForecast.forecast = weather.query.results.channel.item.forecast
                    
                    self.arrayWeatherData.append(dataForecast)
                    
                }
                catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "DONE_GET_DATA"), object: self)
            })
        }.resume()
    }
}
