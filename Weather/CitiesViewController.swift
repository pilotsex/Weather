//
//  ViewController.swift
//  Weather
//
//  Created by Csaba K. on 2019. 03. 30..
//  Copyright © 2019. Csaba K. All rights reserved.
//

import UIKit


struct CityCellData : Codable {
    var cityName : String
    var countyName : String?
    var countryName : String?
}


class CitiesViewController: UITableViewController {

    var cityCellData : Array<CityCellData>
    
    
    required init?(coder aDecoder: NSCoder) {
        cityCellData = []
        super.init(coder: aDecoder)
        if let loadedCities = loadCities() {
            cityCellData = loadedCities
        }
        else {
            cityCellData = defaultCities()
        }
    }
    
    
    func loadCities() -> [CityCellData]? {
        if let loadedCellData = UserDefaults.standard.data(forKey: "Cities") {
            print("successfully loaded from defaults")
            if let decodedData = try? JSONDecoder().decode(Array<CityCellData>.self, from: loadedCellData) {
                return decodedData
            }
        }
        return nil
    }
    
    
    func saveCities() {
        if let data = try? JSONEncoder().encode(cityCellData) {
            UserDefaults.standard.set(data, forKey: "Cities")
        }
        
    }
    
    
    func defaultCities() -> [CityCellData] {
        return
            [CityCellData(cityName: "Sopron", countyName: "Gy-M-S megye", countryName: "hu"),
             CityCellData(cityName: "Győr", countyName: "Gy-M-S megye", countryName: "hu"),
             CityCellData(cityName: "Budapest", countyName: "Pest megye", countryName: "hu"),
             CityCellData(cityName: "Mucsa", countyName: "Nonexistent megye", countryName: "hu")]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = cityCellData[indexPath.row].cityName
        cell.detailTextLabel?.text = cityCellData[indexPath.row].countyName
        return cell
    }
    
}

