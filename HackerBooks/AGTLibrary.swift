//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Alejandro on 02/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

class AGTLibrary {
    private let favoritesTagName = "favorites"
    
    private var books = [AGTBook]()
    private var tags = Tags()
    
    // MARK: - Properties
    
    /**
     *  Total amount of books.
     */
    var booksCount: Int {
        return books.count
    }
    
    var tagNames: [String] {
        return tags.tagNames
    }
    
    // MARK: - Initialization
    
    init(jsonData data: NSData) throws {
        let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        
        var jsonBooks: JSONArray?
        if maybeArray is JSONArray {
            jsonBooks = maybeArray as? JSONArray
        } else if let dict = maybeArray as? JSONDictionary {
            jsonBooks = [dict]
        }
        
        let nc = NSNotificationCenter.defaultCenter()
        
        // create the model through the JSON file
        for dict in jsonBooks! {
            let book = try decode(book: dict)
            books.append(book)
            
            // create the tags
            for tag in book.tags {
                tags.add(tag, book: book)
            }
            
            // if the book is favorite then insert in favorites tag
            if book.favorite {
                tags.add(favoritesTagName, book: book)
            }
            
            nc.addObserver(self, selector: #selector(bookDidChange), name: FavoriteDidChangeNotification, object: nil)
        }
    }
    
    // MARK: - Notification management
    
    @objc func bookDidChange(notification: NSNotification) {
        
    }
    
    // MARK: - Query methods
    
    func bookCountForTag(tag: String?) -> Int {
        return tags.bookCountForTag(tag)
    }
    
    func booksCountForTagAtIndex(tagIndex: Int) -> Int {
        return tags.booksCountForTagAtIndex(tagIndex)
    }
    
    func booksForTagAtIndex(tagIndex: Int) -> [AGTBook] {
        return tags.booksForTagAtIndex(tagIndex)
    }
    
    // MARK: - Data manipulation
    
    func sort() {
        
    }
}