//
//  CityDetailsCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 27/03/22.
//

import UIKit

class CityDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelMainWeather: UILabel!
    @IBOutlet weak var labelCurrentTemparature: UILabel!
    @IBOutlet weak var labelHighTemparature: UILabel!
    @IBOutlet weak var labelLowTemparature: UILabel!
    @IBOutlet weak var labelAlertAdvisory: UILabel!
    @IBOutlet weak var collectionViewHourlyTemparature: UICollectionView!
    @IBOutlet weak var constraintWeeklyTemparatureHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintWeatherDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var tableWeeklyTemparature: UITableView!
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var tableDetails: UITableView!
    
    var city: City? {
        didSet {
            guard let city = city else { return }
            labelCityName.text = city.name
            labelMainWeather.text = (city.weather?.current.weather.first?.main.rawValue ?? "").capitalized
            labelCurrentTemparature.text = "\(city.weather?.current.temp.toInt.toString ?? "")°"
            labelHighTemparature.text = "H:\(city.weather?.daily.first?.temp.max.toInt.toString ?? "")°"
            labelLowTemparature.text = "L:\(city.weather?.daily.first?.temp.min.toInt.toString ?? "")°"
            labelAlertAdvisory.text = city.weather?.alerts?.compactMap { $0.senderName }.joined(separator: " | ")
            let alertsString = city.weather?.alerts?.compactMap { "\($0.alertDescription): \($0.alertDescription)" }.joined(separator: ". ")
            labelAlert.text = alertsString ?? "No severe weather alerts in this area."
            weatherDetilsComponent.removeAll()
            weatherDetilsComponent.append([
                WeatherAreaDetails(title: "SUNRISE", value: Date(timeIntervalSince1970: TimeInterval(city.weather?.current.sunrise ?? 0)).getString(format: DateFormat.hourMinute)),
                WeatherAreaDetails(title: "SUNSET", value: Date(timeIntervalSince1970: TimeInterval(city.weather?.current.sunset ?? 0)).getString(format: DateFormat.hourMinute))
            ])
            weatherDetilsComponent.append(
                [WeatherAreaDetails(title: "FEELS LIKE", value: "\(city.weather?.current.feelsLike.toInt.toString ?? "")°"),
                 WeatherAreaDetails(title: "HUMIDITY", value: "\(city.weather?.current.humidity ?? 0)%")
                 
                ])
            weatherDetilsComponent.append(
                [WeatherAreaDetails(title: "WIND", value: "\(((city.weather?.current.windSpeed ?? 0) * 3.6).rounded(toPlaces: 1)) kph"),
                 WeatherAreaDetails(title: "PRESSURE", value: "\(city.weather?.current.pressure ?? 0) hPa")
                 
                ])
            weatherDetilsComponent.append(
                [WeatherAreaDetails(title: "VISIBILITY", value: "\((Double(city.weather?.current.visibility ?? 0) / 1000).rounded(toPlaces: 1)) km"),
                 WeatherAreaDetails(title: "UV INDEX", value: "\(Double(city.weather?.current.uvi ?? 0).rounded(toPlaces: 1))")
                 
                ])
            weatherDetilsComponent.append(
                [WeatherAreaDetails(title: "CLOUDS", value: "\(city.weather?.current.clouds ?? 0)%"),
                 WeatherAreaDetails(title: "DEW POINT", value: "\(city.weather?.current.dewPoint ?? 0)°")
                 
                ])
            collectionViewHourlyTemparature.reloadData()
            tableWeeklyTemparature.reloadData()
            tableDetails.reloadData()
        }
    }
    
    private var weatherDetilsComponent: [[WeatherAreaDetails]] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constraintWeeklyTemparatureHeight.constant = tableWeeklyTemparature.contentSize.height
        constraintWeatherDetailsHeight.constant = tableDetails.contentSize.height
    }
}

// MARK: - Table view data source

extension CityDetailsCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tableDetails ? weatherDetilsComponent.count : city?.weather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableWeeklyTemparature {
            let cellIdentifier = "cellIdentifierDailyWeather"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DailyTemparatureTableViewCell
            cell.daily = city?.weather?.daily[indexPath.row]
            return cell
        }
        let cellIdentifier = "cellIdentifierDetails"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DetailsTableViewCell
        cell.weatherDetails = weatherDetilsComponent[indexPath.row]
        return cell
    }
}

// MARK: - Collection view data source

extension CityDetailsCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return city?.weather?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cellIdentifierHourly"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HourlyTemparatureCollectionViewCell
        cell.current = city?.weather?.hourly[indexPath.item]
        return cell
    }
}

struct WeatherAreaDetails {
    var title: String
    var value: String
}
