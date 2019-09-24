//
//  FilteredBookArchiveCell.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

class FilteredBookArchiveCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
}

extension FilteredBookArchiveCell {
    
    func setupCell() {
        label.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
    }
    
}



