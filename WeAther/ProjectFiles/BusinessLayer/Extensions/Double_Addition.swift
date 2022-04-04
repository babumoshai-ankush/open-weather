//
//  Double_Addition.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 27/03/22.
//

import Foundation

extension Double {
    var toInt: Int {
        return Int(self)
    }
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
