//
//  DataTVCell.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/5/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit

class DataTVCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

