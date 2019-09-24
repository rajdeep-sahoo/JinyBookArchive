//
//  Book.swift
//  JinyBookArchive
//
//  Created by Rajdeep Sahoo on 24/09/19.
//  Copyright © 2019 Rajdeep Sahoo. All rights reserved.
//

struct Book: Decodable {
    let id: String
    var bookTitle: String
    var authorName: String
    var genre: String
    var publisher: String
    var authorCountry: String
    var soldCount: Int
    let imageUrl: String
    var isBookmarked: Bool?

    private enum CodingKeys: String, CodingKey {
        case id, genre, publisher, isBookmarked
        case bookTitle = "book_title", authorName = "author_name", authorCountry = "author_country", soldCount = "sold_count", imageUrl = "image_url"
    }
}

struct BooksList: Decodable {
    let list: [Book]
}

