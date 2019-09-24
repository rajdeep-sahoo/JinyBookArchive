//
//  HomeViewModel.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

// MARK: - Local Methods
extension HomeViewController {
    
    func setupViews() {
        self.navigationItem.title = HOME_SCREEN_TITLE
        setupTableView()
        createBookLibraryButton.isHidden = false
        createBookLibraryButton.setTitleColor(UIColor(rgb: THEME_COLOR), for: .normal)
    }
    
    func refreshView() {
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView?.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    func setupNavigationBar() {
        self.setupNavigationBarButtons()
    }
    
    func setupNavigationBarButtons() {
        if books.count > 0 {
            let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBtnTapped))
            refreshBtn.tintColor = UIColor(rgb: THEME_COLOR)
            filterBtn.setTitle(NO_FILTER, for: .normal)
            filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
            filterBtn.setTitleColor(UIColor(rgb: THEME_COLOR), for: .normal)
            filterBtn.layer.cornerRadius = 3.0
            filterBtn.layer.masksToBounds = true

            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: filterBtn)
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = refreshBtn

        }
    }
    
    
    func hitBookListAPI() {
        APIManager.shared.getRequest(url: BASE_URL, viewController: self, for: BooksList.self, session: URLSession(configuration: URLSessionConfiguration.default), success: { (response) in
            
            self.books = response.list
            
            self.setupViewAfterFetchingBooksArchive()
            
        }) { (error) in
            Utility.shared.showAlert(withMessage: error, from: self)
        }
    }
    
    func setupViewAfterFetchingBooksArchive() {
        DispatchQueue.main.async {
            if self.books.count > 0 {
                self.createBookLibraryButton.isHidden = true
            } else {
                self.createBookLibraryButton.isHidden = false
            }
            
            self.setupNavigationBarButtons()
            
            self.tableView.reloadData()
        }
    }
    
    
    @objc func refreshBtnTapped() {
        hitBookListAPI()
    }
    
    @objc func filterBtnTapped() {
        Utility.shared.delegate = self
        Utility.shared.dropDown(on: UIBarButtonItem(customView: filterBtn), from: self)
        
    }

}


// MARK: - Table View Data Sources
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! BookInfoCell
        Utility.shared.setImage(from: books[indexPath.row].imageUrl, on: cell.bookImageView)
        cell.bookTitleLbl.text = books[indexPath.row].bookTitle
        cell.bookAuthorLbl.text = books[indexPath.row].authorName
        cell.bookGenreLbl.text = books[indexPath.row].genre
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
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToBookInfoVC(book: books[indexPath.row])
    }
    
}


// MARK: - Custom Delegate
extension HomeViewController: FilterOptionDelegate {
    
    func filterOptionSelected(type: FilterType) {
        switch type {
        case .NoFilter:
            filterBtn.setTitle(NO_FILTER, for: .normal)
        case .Genre:
            filterBtn.setTitle(GENRE, for: .normal)
        case .Country:
            filterBtn.setTitle(COUNTRY, for: .normal)
        case .Author:
            filterBtn.setTitle(AUTHOR, for: .normal)
        default:
            break
        }
        
    }
    
}


// MARK: - Routes
extension HomeViewController {
    
    func pushToBookInfoVC(book: Book) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil)
            let bookInfoVC = storyboard.instantiateViewController(withIdentifier: "BookInfoViewController") as! BookInfoViewController
            bookInfoVC.book = book
            self.navigationController?.pushViewController(bookInfoVC, animated: true)
        }
    }
    
}





