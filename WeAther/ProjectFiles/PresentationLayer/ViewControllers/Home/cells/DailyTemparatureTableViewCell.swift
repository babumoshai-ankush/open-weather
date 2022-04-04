//
//  DailyTemparatureTableViewCell.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 27/03/22.
//

import UIKit

class DailyTemparatureTableViewCell: UITableViewCell {
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var labelTemparatureLow: UILabel!
    @IBOutlet weak var labelTemparatureHigh: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    var daily: Daily? {
        didSet {
            guard let daily = daily else { return }
            labelDayName.text = Date(timeIntervalSince1970: TimeInterval(daily.dt)).dayName
            labelTemparatureHigh.text = "\(daily.temp.max.toInt.toString)°"
            labelTemparatureLow.text = "\(daily.temp.min.toInt.toString)°"
            imageViewIcon.image = daily.weather.first?.main.image
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
