//
//  CurrentWeather.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import Foundation

//this is the structure of OWM's 'Current Weather' JSON response
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility: Double?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let name: String
    let cod: Int
    
    struct Clouds: Codable {
        let all: Double?
    }
    
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    struct Main: Codable {
        let temp: Double
        let pressure, humidity: Double
        let tempMin, tempMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String
        let sunrise, sunset: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
    
    struct Wind: Codable {
        let speed: Double?
        let deg: Double?
    }
}
