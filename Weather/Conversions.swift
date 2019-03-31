//
//  Conversions.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 31..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import Foundation


class Conversions {
    
    static func unixTimeToDisplayTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        //dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //dateFormatter.timeZone = self.timeZone
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    
    static func weatherSymbolFor(code: Int) -> Character {
        
        switch code {
        case 200...232: //Group 2xx: Thunderstorm
            return "⛈"
        case 300...321: //Group 3xx: Drizzle
            return "🌨"
        case 500...504: //Group 5xx: Rain
            return "🌧"
        case 511...531: //Group 5xx: Rain (with Snow)
            return "🌨"
        case 600...622: //Group 6xx: Snow
            return "🌨"
        case 701...781: //Group 7xx: Atmosphere
            return "🌫"
        case 800:       //Group 800: Clear
            return "☀️"
        case 801:       //Group 80x: Clouds
            return "🌤"
        case 802:
            return "☁️"
        case 803:
            return "☁️"
        case 804:
            return "☁️"
        default:
            break
        }
        return "-"
    }
}
