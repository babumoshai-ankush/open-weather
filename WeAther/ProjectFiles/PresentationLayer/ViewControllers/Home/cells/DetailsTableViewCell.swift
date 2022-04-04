//
//  DetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Ankush Chakraborty on 27/03/22.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitleColumnOne: UILabel!
    @IBOutlet weak var labelTitleValueOne: UILabel!
    @IBOutlet weak var labelTitleColumnTwo: UILabel!
    @IBOutlet weak var labelTitleValueTwo: UILabel!
    
    var weatherDetails: [WeatherAreaDetails]? {
        didSet {
            if let keyValue = weatherDetails?.first {
                labelTitleColumnOne.text = keyValue.title
                labelTitleValueOne.text = keyValue.value
            }
            if let keyValue = weatherDetails?.last {
                labelTitleColumnTwo.text = keyValue.title
                labelTitleValueTwo.text = keyValue.value
            }
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
