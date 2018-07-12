//
//  ProductCell.swift
//  ReviewAllknowledge
//
//  Created by Brian La on 7/12/18.
//  Copyright © 2018 BrianLa. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    static let identifier = "cell"
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
