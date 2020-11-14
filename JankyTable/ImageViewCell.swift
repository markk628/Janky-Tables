//
//  ImageViewCell.swift
//  JankyTable
//
//  Created by Mark Kim on 11/10/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        textLabel?.text = nil
    }
}
