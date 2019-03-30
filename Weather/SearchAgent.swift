//
//  SearchAgent.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import Foundation

class SearchAgent {
    
    
    //singleton
    static let shared = SearchAgent()
    //static let shared : SearchAgent = {return SearchAgent()}() //singleton with closure, this will allow for more advanced setup in the future
    private init() {}
    
    
    enum ServerResponse {
        case Weather(currentWeather: CurrentWeather)
        case CityNotFound
        case UnknownResponse
    }
    
    
    public func getCurrentWeatherFor(cityName: String) -> ServerResponse {
        //currently, this can't happen, but let's make this future proof
        guard cityName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {return .CityNotFound}
        
        //let's piece together the query url and add percent escapes
        let queryUrl = ServerData.QUERY + cityName + "&APPID=" + ServerData.API_KEY
        guard let encodedQueryUrl = queryUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed) else {return .CityNotFound}
        print(encodedQueryUrl)
        
        //grab the data and decode it
        if let url = URL(string: encodedQueryUrl) {
            if let serverResponse = try? Data(contentsOf: url) {
                if let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from:serverResponse) {
                    return .Weather(currentWeather: currentWeather)
                }
            }
            else {
                return .CityNotFound
            }
        }
        return .UnknownResponse
    }
    
    
}
