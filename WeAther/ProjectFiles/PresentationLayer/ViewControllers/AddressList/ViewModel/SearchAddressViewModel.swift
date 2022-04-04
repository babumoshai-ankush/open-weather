//
//  SearchAddressViewModel.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import Foundation

class SearchAddressViewModel {
    
    var allCities: [[String: AnyObject]]! {
        didSet {
            filteredData = allCities
        }
    }
    var filteredData = [[String: AnyObject]]()
    
    func loadCities(result completion: @escaping ResponseHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? [Dictionary<String, AnyObject>] {                        
                        self.allCities = jsonResult
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                } catch {
                    completion(false, error)
                }
            }
        }
    }
}
