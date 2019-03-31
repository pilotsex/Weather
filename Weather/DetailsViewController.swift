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
    
    //Labels of the 'SummaryPane'
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var weatherSymbolLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var lowHighLabel: UILabel!
    
    //Labels of 'InfoPane1'
    @IBOutlet var sunRiseLabel: UILabel!
    @IBOutlet var sunSetLabel: UILabel!
    
    //Labels of 'InfoPane2'
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    //Labels of 'InfoPane3'
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var cloudinessLabel: UILabel!
    
    
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
                    self.updateUI(with: currentWeather)
                
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
    
    
    private func updateUI(with currentWeather: CurrentWeather) {
        
        //update SummaryPane
        cityLabel.text = currentWeather.name
        weatherSymbolLabel.text = String(Conversions.weatherSymbolFor(code: currentWeather.weather[0].id))
        descriptionLabel.text = currentWeather.weather[0].description
        temperatureLabel.text = String("\(Int(round(currentWeather.main.temp)))°")
        lowHighLabel.text =
            String("\(Int(round(currentWeather.main.tempMin)))° / \(Int(round(currentWeather.main.tempMax)))°")
        
        //update InfoPane1
        sunRiseLabel.text = Conversions.unixTimeToDisplayTime(unixTime: currentWeather.sys.sunrise)
        sunSetLabel.text = Conversions.unixTimeToDisplayTime(unixTime: currentWeather.sys.sunset)
        
        //update InfoPane2
        pressureLabel.text = String("\(round(currentWeather.main.pressure)) hPa")
        humidityLabel.text = String("\(currentWeather.main.humidity) %")
        
        //update InfoPane3
        if let windSpeed = currentWeather.wind.speed {
            windLabel.text = String("\(round(windSpeed * 3.6)) km/h") //Metric: meter/sec
        }
        if let cloudiness = currentWeather.clouds.all {
            cloudinessLabel.text = String("\(cloudiness) %")
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
