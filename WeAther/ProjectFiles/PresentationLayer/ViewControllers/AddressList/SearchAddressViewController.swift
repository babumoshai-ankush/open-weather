//
//  SearchAddressViewController.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import UIKit
import CoreLocation

class SearchAddressViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var newCityAdded: (() -> Void)?
    
    private let cityManager = CityWeatherManager.shared
    private let viewModel = SearchAddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCities()
    }
}

// MARK: - Private methods
private extension SearchAddressViewController {
    func loadCities() {
        showLoading(message: "Loading city list")
        viewModel.loadCities { [unowned self] (isSuccess, error) in
            hideLoading()
            if let error = error {
                // TODO: Handle error
                return
            }
            tableView.reloadData()
        }
    }
}

// MARK: - Table view data source

extension SearchAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        let address = viewModel.filteredData[indexPath.row]
        cell.textLabel?.text = "\((address["name"] as? String) ?? ""), \((address["country"] as? String) ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }
}

// MARK: - Table view delegate
extension SearchAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = viewModel.filteredData[indexPath.row]
        let coordinate = address["coord"] as? [String: Double]
        guard let lat = coordinate?["lat"], let long = coordinate?["lon"] else {
            fatalError("Unable to fetch coordinate")
        }
        cityManager.addNewCity(cityName: (address["name"] as? String) ?? "", zipCode: "", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        dismiss(animated: true) { [unowned self] in
            if let newCityAdded = newCityAdded {
                newCityAdded()
            }
        }
    }
}

// MARK: - Search bar delegate

extension SearchAddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredData = searchText.isEmpty ? viewModel.allCities : viewModel.allCities.filter { (city: [String: AnyObject]) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (city["name"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}
