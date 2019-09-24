//
//  HomeViewModel.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Local Methods
extension HomeViewController {
    
    func setupViews() {
        setupTableView()
        createBookLibraryButton.setTitle(CREATE_BOOK_LIBRARY, for: .normal)
        createBookLibraryButton.layer.cornerRadius = 3
        createBookLibraryButton.setTitleColor(.white, for: .normal)
        createBookLibraryButton.backgroundColor = UIColor(rgb: THEME_COLOR)
        fetchSavedBooksLocally()
        setVisibilityOfCreateBooksArchiveButton()
    }
    
    func refreshView() {
        self.navigationItem.title = HOME_SCREEN_TITLE
        setupNavigationBar()
    }
    
    func viewIsGoingToDisappear() {
        if filterSelected == .NoFilter {
            self.navigationItem.title = " "
        }
    }
    
    func setupTableView() {
        tableView?.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: "BookInfoCell")
        tableView?.register(UINib(nibName: "FilteredBookArchiveCell", bundle: nil), forCellReuseIdentifier: "FilteredBookArchiveCell")
        
    }
    
    func setupNavigationBar() {
        self.setupNavigationBarButtons()
    }
    
    func setupNavigationBarButtons() {
        if books.count > 0 {
            let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBtnTapped))
            refreshBtn.tintColor = UIColor(rgb: THEME_COLOR)
            filterOptionSelected(type: filterSelected)
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
            
            self.setBooksDataSource(responseBooks: response.list)
            
            self.setupViewAfterFetchingBooksArchive()
            
        }) { (error) in
            Utility.shared.showAlert(withMessage: error, from: self)
        }
    }
    
    func setBooksDataSource(responseBooks: [Book]) {
        DispatchQueue.main.async {
            if self.books.count == 0 {
                self.books = responseBooks
                PersistenceManager.shared.saveResponseLocally(booksData: responseBooks)
            } else {
                for responseBook in responseBooks {
                    if self.books.contains(where: {$0.id == responseBook.id}) == false {
                        self.books.append(responseBook)
                    }
                }
                PersistenceManager.shared.saveResponseLocally(booksData: self.books)
            }
        }
    }
    
    func setupViewAfterFetchingBooksArchive() {
        DispatchQueue.main.async {
            self.setVisibilityOfCreateBooksArchiveButton()
        }
    }
    
    func filterList(filterType: FilterType) {
        
        var dictionary: [String: [Book]] = [String: [Book]]()
        
        switch filterType {
        case .NoFilter:
            books = books.sorted(by: { $0.bookTitle.uppercased() < $1.bookTitle.uppercased() })
        case .Author:
            for book in books {
                let key = String(book.authorName.uppercased())
                if var contacts = dictionary[key] {
                    contacts.append(book)
                    dictionary[key] = contacts
                } else {
                    dictionary[key] = [book]
                }
            }
        case .Country:
            for book in books {
                let key = String(book.authorCountry.uppercased())
                if var contacts = dictionary[key] {
                    contacts.append(book)
                    dictionary[key] = contacts
                } else {
                    dictionary[key] = [book]
                }
            }
        case .Genre:
            for book in books {
                let key = String(book.genre.uppercased())
                if var contacts = dictionary[key] {
                    contacts.append(book)
                    dictionary[key] = contacts
                } else {
                    dictionary[key] = [book]
                }
            }
        }
        
        filteredBookArchive = dictionary
        filteredBookArchiveData = filteredBookArchive.keys.sorted(by: <)
        
        self.tableView.reloadData()
    }
    
    func deleteBook(indexPath: IndexPath) {
        
        Utility.shared.showAlertWithYESNOAction(withMessage: DELETE_WARNING, from: self) { (status) in
            switch status {
            case .YES:
                PersistenceManager.shared.deleteBookMarkLocally(book: self.books[indexPath.row])
                self.books.remove(at: indexPath.row)
                self.setVisibilityOfCreateBooksArchiveButton()
            case .NO:
                break
            }
        }
        
    }
    
    func setBookmarkStatus(indexPath: IndexPath) {
        if books[indexPath.row].isBookmarked == nil {
            books[indexPath.row].isBookmarked = true
        } else if let isBookmarked = books[indexPath.row].isBookmarked {
            books[indexPath.row].isBookmarked = !isBookmarked
        }
        PersistenceManager.shared.saveBookMarkLocally(book: books[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func fetchSavedBooksLocally() {
        
        self.books.removeAll()
        
        let context = PersistenceManager.shared.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: BOOK_ENTITY_NAME)
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let book: Book = Book(id: data.value(forKey: BookInfoKeys.id.rawValue) as! String, bookTitle: data.value(forKey: BookInfoKeys.bookTitle.rawValue) as! String, authorName: data.value(forKey: BookInfoKeys.authorName.rawValue) as! String, genre: data.value(forKey: BookInfoKeys.genre.rawValue) as! String, publisher: data.value(forKey: BookInfoKeys.publisher.rawValue) as! String, authorCountry: data.value(forKey: BookInfoKeys.authorCountry.rawValue) as! String, soldCount: data.value(forKey: BookInfoKeys.soldCount.rawValue) as! Int, imageUrl: data.value(forKey: BookInfoKeys.imageUrl.rawValue) as! String, isBookmarked: data.value(forKey: BookInfoKeys.isBookmarked.rawValue) as? Bool)
                self.books.append(book)
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func createBookArchiveBtnTapped() {
        hitBookListAPI()
    }
    
    func setVisibilityOfCreateBooksArchiveButton() {
        if self.books.count == 0 {
            createBookLibraryButton.isHidden = false
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        } else {
            createBookLibraryButton.isHidden = true
            self.setupNavigationBarButtons()
        }
        self.tableView.reloadData()
    }
    
    @objc func refreshBtnTapped() {
        filterSelected = .NoFilter
        filterOptionSelected(type: filterSelected)
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
        
        if filterSelected == .NoFilter {
            
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
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilteredBookArchiveCell", for: indexPath) as! FilteredBookArchiveCell
            cell.label.text = filteredBookArchiveData[indexPath.row].capitalized
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if filterSelected == .NoFilter {
            let deleteAction = UIContextualAction(style: .normal, title: DELETE, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                
                self.deleteBook(indexPath: indexPath)
                
                success(true)
            })
            deleteAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if filterSelected == .NoFilter {
            
            var isBookmark = false
            
            if books[indexPath.row].isBookmarked == nil {
                isBookmark = false
            } else if let isBookmarked = books[indexPath.row].isBookmarked {
                isBookmark = isBookmarked
            }
            
            let bookmarkAction = UIContextualAction(style: .normal, title: isBookmark ? REMOVE_BOOKMARK : BOOKMARK, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                
                self.setBookmarkStatus(indexPath: indexPath)
                
                success(true)
            })
            bookmarkAction.backgroundColor = isBookmark ? .orange : .blue
            
            return UISwipeActionsConfiguration(actions: [bookmarkAction])
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterSelected == .NoFilter {
            return books.count
        } else {
            return filteredBookArchiveData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

// MARK: - Table View Delegates
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterSelected == .NoFilter {
            pushToBookInfoVC(book: books[indexPath.row])
        } else {
            pushToBooksListVC(books: filteredBookArchive[filteredBookArchiveData[indexPath.row].uppercased()]!)
        }
        
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
        }
        filterSelected = type
        filterList(filterType: filterSelected)
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
    
    func pushToBooksListVC(books: [Book]) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil)
            let booksListVC = storyboard.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
            booksListVC.books = books
            self.navigationController?.pushViewController(booksListVC, animated: true)
        }
    }
    
}





