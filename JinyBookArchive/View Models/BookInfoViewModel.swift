//
//  BookInfoViewModel.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

// MARK: - Local Methods
extension BookInfoViewController {
    
    func setupViews() {
        setupNavigationBar()
        setupTableView()
        Utility.shared.setImage(from: book.imageUrl, on: bookImage)
        bookTitle.text = book.bookTitle
    }
    
    func setupTableView() {
        tableView?.register(UINib(nibName: "BookDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: THEME_COLOR)
    }
    
}

// MARK: - Table View Data Sources
extension BookInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! BookDetailCell
        
        switch indexPath.row {
        case 0:
            cell.detailLbl.text = AUTHOR
            cell.infoLbl.text = book.authorName
        case 1:
            cell.detailLbl.text = GENRE
            cell.infoLbl.text = book.genre
        case 2:
            cell.detailLbl.text = COUNTRY
            cell.infoLbl.text = book.authorCountry
        case 3:
            cell.detailLbl.text = PUBLISHER
            cell.infoLbl.text = book.publisher
        case 4:
            cell.detailLbl.text = SOLD
            cell.infoLbl.text = "\(book.soldCount)" + " " + UNITS
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
