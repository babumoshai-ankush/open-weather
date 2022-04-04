//
//  CityDataManagerError.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 26/03/22.
//

import Foundation

enum CityDataManagerError: Error {
    case alreadyAdded
    case notFound
    case noList
    case unexpected(code: Int)
}

// For each error type return the appropriate description
extension CityDataManagerError: CustomStringConvertible {
    var description: String {
        switch self {
        case .alreadyAdded:
            return "The specified item is already added."
        case .notFound:
            return "The specified item could not be found."
        case .noList:
            return "No saved city."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}

extension CityDataManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .alreadyAdded:
            return NSLocalizedString(
                "The specified item is already added.",
                comment: "Duplicate resource"
            )
        case .notFound:
            return NSLocalizedString(
                "The specified item could not be found.",
                comment: "Resource Not Found"
            )
        case .noList:
            return NSLocalizedString(
                "The city list found.",
                comment: "City List Not Found"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}
