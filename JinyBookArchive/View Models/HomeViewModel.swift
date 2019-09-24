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
        setupNavigationBar()
        setupTableView()
        createBookLibraryButton.isHidden = false
    }
    
    func setupTableView() {
        tableView?.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setItems([UINavigationItem(title: HOME_SCREEN_TITLE)], animated: false)
        self.setupNavigationBarButtons()
    }
    
    func setupNavigationBarButtons() {
        if books.count > 0 {
            let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBtnTapped))
            refreshBtn.tintColor = UIColor(rgb: THEME_COLOR)
            
            let filterBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
            filterBtn.setTitle("Filter", for: .normal)
            filterBtn.setTitleColor(UIColor(rgb: THEME_COLOR), for: .normal)
            filterBtn.layer.cornerRadius = 3.0
            filterBtn.layer.masksToBounds = true

            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [refreshBtn, UIBarButtonItem(customView: filterBtn)]
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
        print("Lorem")
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
        
    }
    
}

