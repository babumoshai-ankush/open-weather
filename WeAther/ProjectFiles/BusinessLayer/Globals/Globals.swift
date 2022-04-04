//
//  Globals.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import Foundation
import Alamofire

enum Router {
    case oneCall
    static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")
}

extension Router: URLConvertible {
    func asURL() throws -> URL {
        let path: String
        switch self {
        case .oneCall:
            path = "onecall"
        }
        let url = Router.baseURL!.appendingPathComponent(path)
        return url
    }
}

typealias ResponseHandler = (_ isSuccess: Bool, _ error: Error?) -> Void
