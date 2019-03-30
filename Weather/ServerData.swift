//
//  ServerData.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import Foundation


struct ServerData {
    
    static let SERVER_NAME = "OpenWeatherMap"
    static let API_KEY = "310845f6cc63ec3e0ce10780fe264596"
    static let SERVER_ADDRESS = "http://api.openweathermap.org"
    static let QUERY = "https://api.openweathermap.org/data/2.5/weather?&units=metric&q="

}


// a query should look like this:
// http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=310845f6cc63ec3e0ce10780fe264596
// metric version
// https://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&APPID=310845f6cc63ec3e0ce10780fe264596
