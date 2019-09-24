//
//  BookDetailCell.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

class BookDetailCell: UITableViewCell {

    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
        
}

extension BookDetailCell {
    
    func setupCell() {
        detailLbl.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
        infoLbl.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
    }
    
}


