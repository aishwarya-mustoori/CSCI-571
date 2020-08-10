//
//  HomeSearchResultsCell.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/27/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit

class HomeSearchResultsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var resultsImage: UIImageView!
    
    @IBOutlet weak var bookmark: UIButton!
    
    @IBOutlet weak var resultsSection: UILabel!
    @IBOutlet weak var resultsTime: UILabel!
    @IBOutlet weak var resultsTitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
            super.layoutSubviews()

            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 0, right:5))
        }
    
}
