//
//  Forecast.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import Foundation



//this is the structure of OWM's 'Forecast' JSON response
struct Forecast: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
    let city: City
    
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Double
    }
    
    struct Coord: Codable {
        let lat, lon: Double
    }
    
    struct List: Codable {
        let dt: Int
        let main: MainClass
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let sys: Sys
        let dtTxt: String
        let rain: Rain?
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, sys
            case dtTxt = "dt_txt"
            case rain
        }
    }
    
    struct Clouds: Codable {
        let all: Double
    }
    
    struct MainClass: Codable {
        let temp, tempMin, tempMax, pressure: Double
        let seaLevel, grndLevel: Double
        let humidity: Double
        let tempKf: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }
    
    struct Rain: Codable {
        let the3H: Double?
        
        enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    }
    
    struct Sys: Codable {
        let pod: String
    }
    
    
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    
    struct Wind: Codable {
        let speed, deg: Double
    }
}


