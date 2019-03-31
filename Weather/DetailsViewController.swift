//
//  DetailsViewController.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UICollectionViewDataSource {

    var city: String?
    var forecastData: Forecast?
    
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
    
    //Forecast collectionView and its height constraint
    @IBOutlet var forecastHeight: NSLayoutConstraint!
    @IBOutlet var forecastCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = city
        forecastCollectionView.dataSource = self
        updateOutput()
    }
    
    
    private func updateOutput() {
        guard let city = city else {return}
        
        //let's grab the actual weather data in a background thread
        DispatchQueue.global().async {
            
            let response = SearchAgent.shared.getCurrentWeatherFor(cityName: city)
            
            //let's go back to the main thread and update the UI
            DispatchQueue.main.async {[unowned self] in
                switch response {
                case .Weather(currentWeather: let currentWeather):
                    self.updateUI(with: currentWeather)
                case .CityNotFound:
                    self.showErrorMessage(withTitle: "Error", message: "City not found")
                case .UnknownResponse:
                    self.showErrorMessage(withTitle: "Unknown Error", message: "It seems, you are out of luck :)")
                }
            }
            
            //let's download the forecast data
            //the side scrolling forecast collectionView is hidden initially (height == 0), we will show it if we can grab valid data from the server
            let forecastResponse = SearchAgent.shared.getForecastFor(cityName: city)
            
            //let's go back to the main thread and update the UI
            DispatchQueue.main.async {[unowned self] in
                switch forecastResponse {
                case .Forecast(forecast: let forecast):
                    self.forecastData = forecast
                    
                    //'open' the forecast view
                    self.forecastHeight.constant = 100
                    self.forecastCollectionView.alpha = 0.0
                    UIView.animate(withDuration: 0.3, animations: {
                       self.forecastCollectionView.alpha = 1.0
                        self.view.layoutIfNeeded()
                        })
                    
                    //populate the collectionView with the new data
                    self.forecastCollectionView.reloadData()
                
                default: break //fail silently, no need to notify the user, the forecast view won't be opened and the forecast data will be missing
                }
            }
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
    
    //forecast collectionView delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = forecastData else {return 0}
        return forecast.list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherTile", for: indexPath)
        guard let forecast = forecastData else {return cell}
        guard indexPath.row < forecast.list.count else {return cell}
        guard forecast.list[indexPath.row].weather.count > 0 else {return cell}
        
        //yes, I hate these magic numbers, too, but this was the easiest way to access the views inside the collectionViewCell
        (cell.viewWithTag(1) as! UILabel).text = Conversions.unixTimeToDisplayTime(unixTime: forecast.list[indexPath.row].dt)
        (cell.viewWithTag(2) as! UILabel).text = String(Int(round(forecast.list[indexPath.row].main.temp)))
        (cell.viewWithTag(3) as! UILabel).text = String(Conversions.weatherSymbolFor(code: forecast.list[indexPath.row].weather[0].id))
        return cell
    }
    
    
}
