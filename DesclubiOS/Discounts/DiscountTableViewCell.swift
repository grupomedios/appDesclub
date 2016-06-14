//
//  DiscountTableViewCell.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 29/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {

	
	@IBOutlet weak var discountImage: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var distance: UILabel!
	@IBOutlet weak var percentagesContainer: UIView!
	@IBOutlet weak var promo: UILabel!
	@IBOutlet weak var cash: UILabel!
	@IBOutlet weak var card: UILabel!
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
