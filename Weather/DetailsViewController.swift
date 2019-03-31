//
//  DetailsViewController.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutput()
    }
    
    
    private func updateOutput() {
        guard let city = city else {return}
        
        //let's grab the actual weather data in a background thread
        DispatchQueue.global().async {
            
            let response = SearchAgent.shared.getCurrentWeatherFor(cityName: city)
            
            //let's go back to the main thread and update the UI
            DispatchQueue.main.async {
                switch response {
                case .Weather(currentWeather: let currentWeather):
                    print(currentWeather)
                
                case .CityNotFound:
                    self.showErrorMessage(withTitle: "Error", message: "City not found")
                case .UnknownResponse:
                    self.showErrorMessage(withTitle: "Unknown Error", message: "It seems, you are out of luck :)")
                }
            }
            
            /*
            let response = SearchAgent.shared.getForecastFor(cityName: city)
            //let's go back to the main thread and update the UI
            DispatchQueue.main.async {
                switch response {
                case .Forecast(forecast: let forecast):
                    print(forecast)
                    
                case .CityNotFound:
                    self.showErrorMessage(withTitle: "Error", message: "City not found")
                case .UnknownResponse:
                    self.showErrorMessage(withTitle: "Unknown Error", message: "It seems, you are out of luck :)")
                }
            }
            */
 
        }
    }
    
    
    private func showErrorMessage(withTitle title: String, message: String) {
        let ac = UIAlertController(title: title , message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[unowned self, ac] (action) in
            ac.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(ac, animated: true)
    }
    
}
