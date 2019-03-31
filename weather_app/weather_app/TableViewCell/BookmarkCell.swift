//
//  BookmarkCell.swift
//  weather_app
//
//  Created by Jessica on 3/30/19.
//  Copyright © 2019 Jessica. All rights reserved.
//

import UIKit

class BookmarkCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var label_cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
