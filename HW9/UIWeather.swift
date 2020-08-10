//
//  UIWeather.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/19/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit

class UIWeather: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var weatherPlace: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    
    @IBOutlet weak var weatherCity: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    override func layoutSubviews() {
               super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 5, right:5))

              
           }
       

}
