//
//  ListOfCitiesViewController.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import UIKit

class ListOfCitiesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var newCityAdded: (() -> Void)?
    private var cityManager = CityWeatherManager.shared
    private var isAddedNewCity = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueListOfCities" {
            let vcAddress = segue.destination as? SearchAddressViewController
            vcAddress?.newCityAdded = { [unowned self] in
                isAddedNewCity = true
                tableView.reloadData()
            }
        }
    }
}

// MARK: - Table view delegate

extension ListOfCitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            cityManager.removeCity(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            isAddedNewCity = true
        }
    }
}

// MARK: - Table view data source

extension ListOfCitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityManager.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "identifierCityListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CityListTableViewCell
        cell.city = cityManager.cities[indexPath.row]
        return cell
    }
}

// MARK: - Button actions

extension ListOfCitiesViewController {
    @IBAction func buttonBackOnTap(_ sender: UIButton) {
        if isAddedNewCity, let newCityAdded = newCityAdded {
            newCityAdded()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
