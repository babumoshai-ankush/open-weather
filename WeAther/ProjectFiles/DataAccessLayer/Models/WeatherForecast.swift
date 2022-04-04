//
//  ResponseModel.swift
//  WeAther
//
//  Created by PC-010 on 25/03/22.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - WeatherForecast

struct WeatherForecast: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    let alerts: [Alert]?

    static func resource(coordinate: CLLocationCoordinate2D) -> Resource<WeatherForecast> {
        do {
            let url = try Router.oneCall.asURL()
            let queryItems = [URLQueryItem(name: "lat", value: coordinate.latitude.description), URLQueryItem(name: "lon", value: coordinate.longitude.description), URLQueryItem(name: "exclude", value: "minutely"),URLQueryItem(name: "appid", value: weatherAPIKey), URLQueryItem(name: "units", value: "metric")]
            var urlComps = URLComponents(string: url.absoluteString)
            urlComps?.queryItems = queryItems
            guard let completeUrl = urlComps?.url else {
                fatalError("Invalid URL")
            }
            var res = Resource<WeatherForecast>(url: completeUrl)
            res.httpMethod = .get
            return res
        } catch {
            fatalError("Unable to create ResponseModel resource = \(error.localizedDescription)")
        }
    }

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily, alerts
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case snow = "Snow"
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"
}

extension Main {
    var image: UIImage? {
        switch(self) {
        case .clear:
            return UIImage(systemName: "sun.max")
        case .clouds:
            return UIImage(systemName: "cloud")
        case .rain:
            return UIImage(systemName: "cloud.rain")
        case .thunderstorm:
            return UIImage(systemName: "cloud.bolt.rain")
        case .drizzle:
            return UIImage(systemName: "cloud.drizzle")
        case .snow:
            return UIImage(systemName: "snowflake")
        case .smoke:
            return UIImage(systemName: "smoke")
        case .haze:
            return UIImage(systemName: "sun.haze")
        case .dust, .ash, .sand:
            return UIImage(systemName: "sun.dust")
        case .fog, .squall, .mist:
            return UIImage(systemName: "cloud.fog")
        case .tornado:
            return UIImage(systemName: "tornado")
        }
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - Alert
struct Alert: Codable {
    let senderName, event: String
    let start, end: Int
    let alertDescription: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end
        case alertDescription = "description"
        case tags
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
