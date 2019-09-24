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
        hitBookListAPI()
    }
    
    func setupTableView() {
//        tableView?.register(UINib(nibName: "ContactsListCell", bundle: nil), forCellReuseIdentifier: reuseId)
//        tableView?.sectionIndexColor = UIColor(rgb: TEXT_GRAY_COLOR)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setItems([UINavigationItem(title: "Books Archive")], animated: false)
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
    
    func hitBookListAPI() {
        APIManager.shared.getRequest(url: BASE_URL, viewController: self, for: BooksList.self, session: URLSession(configuration: URLSessionConfiguration.default), success: { (response) in
            print(response)
        }) { (error) in
            Utility.shared.showAlert(withMessage: error, from: self)
        }
    }
    
    @objc func refreshBtnTapped() {
        print("Ipsum")
    }
    
    @objc func filterBtnTapped() {
        print("Lorem")
    }

}
