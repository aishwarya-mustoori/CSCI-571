//
//  UIHomeTableViewCell.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/18/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UIHomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var homeSection: UILabel!
    @IBOutlet weak var homeTime: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var homeTitle: UILabel!
    
    override func layoutSubviews() {
            super.layoutSubviews()

            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 5, right:5))
        }
    

}
