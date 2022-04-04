//
//  city.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 26/03/22.
//

import Foundation
import CoreLocation

class City: NSObject, NSCoding {
    var cityId: Int
    var name: String
    var zipCode: String
    var coordinate: CLLocationCoordinate2D
    var weather: WeatherForecast?
    
    private init(cityId: Int, name: String, zipCode: String, coordinate: CLLocationCoordinate2D) {
        self.cityId = cityId
        self.name = name
        self.zipCode = zipCode
        self.coordinate = coordinate
    }
    
    convenience init(name: String, zipCode: String, coordinate: CLLocationCoordinate2D) {
        self.init(cityId: 0, name: name, zipCode: zipCode, coordinate: coordinate)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(cityId, forKey: "cityId")
        coder.encode(name, forKey: "name")
        coder.encode(zipCode, forKey: "zipCode")
        coder.encode("\(coordinate.latitude),\(coordinate.longitude)", forKey: "coordinate")
    }
    
    required init?(coder: NSCoder) {
        cityId = coder.decodeInteger(forKey: "cityId")
        name = coder.decodeObject(forKey: "name") as! String
        zipCode = coder.decodeObject(forKey: "zipCode") as! String
        let coordinateString = coder.decodeObject(forKey: "coordinate") as! String
        let latLongArray = coordinateString.components(separatedBy: ",")
        coordinate = CLLocationCoordinate2D(latitude: Double(latLongArray.first!) ?? 0, longitude: Double(latLongArray.last!) ?? 0)
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return (lhs.cityId == rhs.cityId && lhs.name == rhs.name && lhs.zipCode == rhs.zipCode && lhs.coordinate == rhs.coordinate )
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let city = object as? City else { return false }
        return (cityId == city.cityId && name == city.name && zipCode == city.zipCode && coordinate == city.coordinate )
    }
    
    override var description: String {
        get {
            return "id: \(cityId) name: \(name) zipCode: \(zipCode) coordinate: \(coordinate)"
        }
    }
}
