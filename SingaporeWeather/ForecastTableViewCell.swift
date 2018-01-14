//
//  ForecastTableViewCell.swift
//  SingaporeWeather
//
//  Created by Ammar Rusydi on 13/01/2018.
//  Copyright © 2018 Ammar. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempRangeLbl: UILabel!    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
