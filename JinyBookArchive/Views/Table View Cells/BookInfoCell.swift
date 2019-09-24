//
//  BookInfoCell.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

class BookInfoCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLbl: UILabel!
    @IBOutlet weak var bookAuthorLbl: UILabel!
    @IBOutlet weak var bookGenreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
}

extension BookInfoCell {
    
    func setupCell() {
        bookImageView.maskBorder(borderWidth: 0.5, borderColor: UIColor(rgb: TEXT_GRAY_COLOR).cgColor)
        bookTitleLbl.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
        bookAuthorLbl.textColor = UIColor(rgb: TEXT_BLACK_COLOR)
        bookGenreLbl.textColor = UIColor(rgb: TEXT_GRAY_COLOR)
    }
    
    
}

