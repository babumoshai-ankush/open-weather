//
//  CityListTableViewCell.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 28/03/22.
//

import UIKit

class CityListTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemparature: UILabel!

    var city: City? {
        didSet {
            guard let city = city else { return }
            labelCityName.text = city.name
            let temp = city.weather?.current.temp.toInt.toString
            labelTemparature.text = temp == nil ? "--" : "\(temp!)°"
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
