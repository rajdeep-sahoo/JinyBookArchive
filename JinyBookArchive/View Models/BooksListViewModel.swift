//
//  BooksListViewModel.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

// MARK: - Local Methods
extension BooksListViewController {
    
    func setupViews() {
        self.navigationItem.title = " "
        setupTableView()
    }
    
    func setupTableView() {
        tableView?.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: "BookInfoCell")
    }

}


// MARK: - Table View Data Sources
extension BooksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookInfoCell", for: indexPath) as! BookInfoCell
        Utility.shared.setImage(from: books[indexPath.row].imageUrl, on: cell.bookImageView)
        cell.bookTitleLbl.text = books[indexPath.row].bookTitle
        cell.bookAuthorLbl.text = books[indexPath.row].authorName
        cell.bookGenreLbl.text = books[indexPath.row].genre
        
        if let bookmarkStatus = books[indexPath.row].isBookmarked {
            cell.backgroundColor = bookmarkStatus ? UIColor(rgb: BOOKMARKED_COLOR) : .white
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

// MARK: - Table View Delegates
extension BooksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToBookInfoVC(book: books[indexPath.row])
    }
    
}



// MARK: - Routes
extension BooksListViewController {
    
    func pushToBookInfoVC(book: Book) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil)
            let bookInfoVC = storyboard.instantiateViewController(withIdentifier: "BookInfoViewController") as! BookInfoViewController
            bookInfoVC.book = book
            self.navigationController?.pushViewController(bookInfoVC, animated: true)
        }
    }
    
}

