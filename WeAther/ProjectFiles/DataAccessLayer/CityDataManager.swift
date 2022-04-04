//
//  CityDataManager.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 26/03/22.
//

import Foundation

class CityDataManager {
    fileprivate let key = "UD@CityDataManager"
    fileprivate let userDefaults = UserDefaults.standard
}

// MARK: - Internal methods

extension CityDataManager {
    func reset() {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    func remove(city: City) throws {
        do {
            guard
                let data = userDefaults.object(forKey: key) as? Data,
                var allCities = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [City] else {
                    throw CityDataManagerError.notFound
                }
            allCities.removeAll { !$0.zipCode.isEmpty ? $0.zipCode == city.zipCode : $0.name == city.name }
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: allCities, requiringSecureCoding: false)
            userDefaults.set(archivedData, forKey: key)
            userDefaults.synchronize()
        } catch {
            throw error
        }
    }
    
    func add(city: City) throws {
        do {
            if !isExist(city: city) {
                guard let cityList = userDefaults.object(forKey: key) as? Data else {
                    try writeToUserDefaults(city: city, savedData: nil)
                    return
                }
                try writeToUserDefaults(city: city, savedData: cityList)
            }
        } catch {
            throw error
        }
    }
    
    func fetchCities() throws -> [City]  {
        do {
            guard
                let data = userDefaults.object(forKey: key) as? Data,
                let allCities = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [City] else {
                    return []
                }
            return allCities
        } catch {
            throw error
        }
    }
}

// MARK: - Private methods
private extension CityDataManager {
    func writeToUserDefaults(city: City, savedData: Data?) throws {
        do {
            var allCities = [City]()
            if
                let savedData = savedData,
                let savedCities = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [City]{
                allCities.append(contentsOf: savedCities)
            }
            city.cityId = allCities.count + 1
            allCities.isEmpty ? allCities.append(city) : allCities.insert(city, at: 0)
            let data = try NSKeyedArchiver.archivedData(withRootObject: allCities, requiringSecureCoding: false)
            userDefaults.set(data, forKey: key)
            userDefaults.synchronize()
        } catch {
            throw error
        }
    }
    
    func isExist(city: City) -> Bool {
        do {
            guard
                let data = userDefaults.object(forKey: key) as? Data,
                let allCities = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [City] else {
                    return false
                }
            return allCities.contains { !$0.zipCode.isEmpty ? $0.zipCode == city.zipCode : $0.name == city.name }
        } catch {
            return false
        }
    }
}
