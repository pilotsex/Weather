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

    private var cityCellData : Array<CityCellData>
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Weather"
        //TODO the placements of the Edit/Add buttons are a little unconventional, I should move the Add button to the footer or something
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain , target: self, action: #selector(editTable))
    }
    
    
    // the amount of data is quite small, using defaults here is reasonable
    private func saveCities() {
        if let data = try? JSONEncoder().encode(cityCellData) {
            UserDefaults.standard.set(data, forKey: "Cities")
        }
        
    }
    
    
    private func loadCities() -> [CityCellData]? {
        if let loadedCellData = UserDefaults.standard.data(forKey: "Cities") {
            if let decodedData = try? JSONDecoder().decode(Array<CityCellData>.self, from: loadedCellData) {
                return decodedData
            }
        }
        return nil
    }
    
    
    // The default city list. According to the specification, the list should also contain a nonexistent city. Guess, which one is it? :)
    private func defaultCities() -> [CityCellData] {
        return
            [CityCellData(cityName: "Sopron", countyName: "Gy-M-S megye", countryName: "hu"),
             CityCellData(cityName: "Győr", countyName: "Gy-M-S megye", countryName: "hu"),
             CityCellData(cityName: "Budapest", countyName: "Pest megye", countryName: "hu"),
             CityCellData(cityName: "Mucsa", countyName: "Nonexistent megye", countryName: "hu")]
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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cityCellData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        saveCities()
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCellData = cityCellData[sourceIndexPath.row]
        cityCellData.remove(at: sourceIndexPath.row)
        cityCellData.insert(movedCellData, at: destinationIndexPath.row)
        saveCities()
    }
    
    
    //dummy method for validating the name of the new city for existence
    //we should perform a test query or use some more specific api call for a proper name validation
    private func validateNewCity(cityName: String) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else {return}
        guard let detailsViewController = segue.destination as? DetailsViewController else {return}
       
        //detailsViewController.city = cell.textLabel?.text //shitty solution
        //let's use the data model instead
        detailsViewController.city = cityCellData[tableView.indexPath(for: cell)!.row].cityName
    }
    
    
    @objc private func addCity() {
        let actionSheet = UIAlertController(title: "Add new city", message: "Please enter the name of the city", preferredStyle: .alert)
        actionSheet.addTextField()
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Add", style: .default) {[unowned self](alertAction) in
            let textFieldText = actionSheet.textFields?[0].text
            if let trimmedTextFieldText = textFieldText?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if self.validateNewCity(cityName: trimmedTextFieldText) {
                    self.cityCellData.append(CityCellData(cityName: trimmedTextFieldText.lowercased().capitalized(with: Locale.current), countyName: nil, countryName: nil))
                    self.tableView.reloadData()
                    self.saveCities()
                }
                self.dismiss(animated: true)
            }
        })

        present(actionSheet, animated: true)
    }
    
    
    @objc private func editTable(source: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        source.title = tableView.isEditing ? "Done" : "Edit"
    }
}

