//
//  PersistenceManager.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 25/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

import CoreData

final class PersistenceManager {
    
    private init() {}
    
    static let shared = PersistenceManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CORE_DATA_MODEL)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Helpers for Books Archive
    func saveBookMarkLocally(book: Book) {
        
        let context = self.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: BOOK_ENTITY_NAME)
        request.predicate = NSPredicate(format: "\(BookInfoKeys.id.rawValue) = %@", "\(book.id)")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(book.isBookmarked, forKey: BookInfoKeys.isBookmarked.rawValue)
            }
            
        } catch {
            print("Failed")
        }
        
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteBookMarkLocally(book: Book) {
        
        let context = self.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: BOOK_ENTITY_NAME)
        request.predicate = NSPredicate(format: "\(BookInfoKeys.id.rawValue) = %@", "\(book.id)")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
            
        } catch {
            print("Failed")
        }
        
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func saveResponseLocally(booksData: [Book]) {
        
        deleteAllLocalData()
        
        let context = self.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: BOOK_ENTITY_NAME, in: context)
        
        for book in booksData {
            let bookSaveLocally = NSManagedObject(entity: entity!, insertInto: context)
            bookSaveLocally.setValue(book.id, forKey: BookInfoKeys.id.rawValue)
            bookSaveLocally.setValue(book.bookTitle, forKey: BookInfoKeys.bookTitle.rawValue)
            bookSaveLocally.setValue(book.authorName, forKey: BookInfoKeys.authorName.rawValue)
            bookSaveLocally.setValue(book.genre, forKey: BookInfoKeys.genre.rawValue)
            bookSaveLocally.setValue(book.publisher, forKey: BookInfoKeys.publisher.rawValue)
            bookSaveLocally.setValue(book.authorCountry, forKey: BookInfoKeys.authorCountry.rawValue)
            bookSaveLocally.setValue(book.soldCount, forKey: BookInfoKeys.soldCount.rawValue)
            bookSaveLocally.setValue(book.imageUrl, forKey: BookInfoKeys.imageUrl.rawValue)
            
            if book.isBookmarked == nil {
                bookSaveLocally.setValue(false, forKey: BookInfoKeys.isBookmarked.rawValue)
            } else if let bookmarkStatus = book.isBookmarked {
                bookSaveLocally.setValue(bookmarkStatus, forKey: BookInfoKeys.isBookmarked.rawValue)
            }
            
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    
    
    func deleteAllLocalData() {
        let context = self.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: BOOK_ENTITY_NAME)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
}
