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
    let list: [List]
    
    struct List: Codable {
        let dt: Double
        let main: MainClass
        let weather: [Weather]
    }
    
    struct MainClass: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}


