//
//  PoliticsCells.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/20/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit

class PoliticsCells: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var mainBookmark: UIButton!
    @IBOutlet weak var mainSection: UILabel!
    @IBOutlet weak var mainTime: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 0, right:5))
    }
}
