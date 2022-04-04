//
//  CLLocationCoordinate2D_Addition.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 26/03/22.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}
