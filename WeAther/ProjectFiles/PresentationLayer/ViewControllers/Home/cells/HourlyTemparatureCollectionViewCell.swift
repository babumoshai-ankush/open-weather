//
//  HourlyTemparatureCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 27/03/22.
//

import UIKit

class HourlyTemparatureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTemparature: UILabel!
    
    var current: Current? {
        didSet {
            guard let current = current else { return }
            let isCurrentTime = Date(timeIntervalSince1970: TimeInterval(current.dt)).isHourSame
            labelTime.text = isCurrentTime ? "Now" : Date(timeIntervalSince1970: TimeInterval(current.dt)).getString(format: DateFormat.hour)
            imageViewIcon.image = current.weather.first?.main.image
            labelTemparature.text = "\(current.temp.toInt)°"            
        }
    }
}
