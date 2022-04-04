//
//  ViewModel.swift
//  WeAther
//
//  Created by PC-010 on 25/03/22.
//

import Foundation
import UIKit
import CoreLocation

class CityWeatherManager {
    static let shared = CityWeatherManager()
    private lazy var apiManager: APIClient = {
        return APIClient()
    }()
    private var responseHandler: ResponseHandler!
    private var dataManager: CityDataManager
    private(set) var cities: [City]
    
    private init() {
        dataManager = CityDataManager()
        cities = []
        fetchCities()
    }
}

// MARK: - Internal methods

extension CityWeatherManager {
    func removeCity(index: Int) {
        do {
            try dataManager.remove(city: cities[index])
            fetchCities()
        } catch CityDataManagerError.notFound {
            print("Error: City noy found added")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    func addNewCity(cityName city: String, zipCode zip: String, coordinate latLong: CLLocationCoordinate2D) {
        do {
            try dataManager.add(city: City(name: city, zipCode: zip, coordinate: latLong))
            fetchCities()
        } catch CityDataManagerError.alreadyAdded {
            print("Error: Already added")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addNewAndFetchAllCityWeather(cityName city: String, zipCode zip: String, coordinate latLong: CLLocationCoordinate2D, completion response: @escaping ResponseHandler) {
        responseHandler = response
        do {
            try dataManager.add(city: City(name: city, zipCode: zip, coordinate: latLong))
            fetchCities()
        } catch CityDataManagerError.alreadyAdded {
            print("Already added")
        } catch {
            responseHandler(false, error)
            return
        }
        fetchWeatherForecast()
    }
    
    func fetchAllCityWeather(completion response: @escaping ResponseHandler) {
        responseHandler = response
        fetchWeatherForecast()
    }
}

// MARK: - Private methods

private extension CityWeatherManager {
    func fetchWeatherForecast() {
        var isSuccess = true
        let groupOperation = DispatchGroup()
        DispatchQueue.global().async { [unowned self] in
            cities.forEach { city in
                groupOperation.enter()
                if city.weather == nil {
                    apiManager.load(resource: WeatherForecast.resource(coordinate: city.coordinate)) { result in
                        switch result {
                        case .success(let result):
                            city.weather = result
                        case .failure:
                            isSuccess = false
                        }
                        groupOperation.leave()
                    }
                } else {
                    groupOperation.leave()
                }
                groupOperation.wait()
            }
            groupOperation.notify(queue: .main) { [unowned self] in
                responseHandler(isSuccess, !isSuccess ? APIClientError.custom(message: "Something went wrong. Please try after sometime.", httpStatus: nil) : nil)
            }
        }
    }
    
    func fetchCities() {
        do {
            cities = try dataManager.fetchCities()
        } catch {
            responseHandler(false, error)
        }
    }
}
