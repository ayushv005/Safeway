//
//  TableCellSideBar.swift
//  sample1
//
//  Created by Ayush Verma on 13/06/16.
//  Copyright © 2016 Ayush Verma. All rights reserved.
//

import UIKit

class TableCellSideBar: UITableViewCell {
    @IBOutlet weak var imgcell: UIImageView!
    @IBOutlet weak var labelcell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
