//
//  FaqTableCell.swift
//  sample1
//
//  Created by Ayush Verma on 07/07/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit

class FaqTableCell: UITableViewCell {
    
    @IBOutlet var ques: UILabel!
    @IBOutlet var ans: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
