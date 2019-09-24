//
//  HomeViewController.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var createBookLibraryButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Local Variables
    var books = [Book]()
    let reuseId = "BookInfoCell"
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshView()
    }
    
    // MARK: - @IBActions
    @IBAction func createBookLibBtnClicked(_ sender: Any) {
        hitBookListAPI()
    }
}

