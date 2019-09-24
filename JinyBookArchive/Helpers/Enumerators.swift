//
//  Enumerators.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

enum FilterType {
    case Author, Genre, Country, NoFilter
}

enum UIAlertActionTypeSelected {
    case YES, NO
}

enum BookInfoKeys: String {
    case id, bookTitle, authorName, genre, publisher, authorCountry, soldCount, imageUrl, isBookmarked
}
