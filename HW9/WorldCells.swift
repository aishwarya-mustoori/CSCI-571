//
//  WorldCells.swift
//  
//
//  Created by Aishwarya Mustoori on 4/20/20.
//

import UIKit

class WorldCells: UITableViewCell {
    @IBOutlet weak var worldImage: UIImageView!
    
    @IBOutlet weak var worldBookmark: UIButton!
    @IBOutlet weak var worldSection: UILabel!
    @IBOutlet weak var worldTime: UILabel!
    @IBOutlet weak var worldTitle: UILabel!
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
