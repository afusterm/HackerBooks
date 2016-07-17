//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Alejandro on 02/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

let favoritesTagName = "favorites"

class AGTLibrary {
    private var books = [AGTBook]()
    private var tags = Tags()
    
    var delegate: AGTLibraryDelegate?
    
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
    
    init(jsonData data: NSData, favorites: [String]?) throws {
        let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        
        var jsonBooks: JSONArray?
        if maybeArray is JSONArray {
            jsonBooks = maybeArray as? JSONArray
        } else if let dict = maybeArray as? JSONDictionary {
            jsonBooks = [dict]
        }
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: favoriteDidChangeNotification, object: nil)
        
        // create the model through the JSON file
        for dict in jsonBooks! {
            let book = try decode(book: dict)
            books.append(book)
            
            // create the tags
            for tag in book.tags {
                tags.add(tag, book: book)
            }
            
            // if the book was saved as favorite then it is added in the favorites tag
            if let favs = favorites  {
                if favs.contains(book.title) {
                    tags.add(favoritesTagName, book: book)
                    book.favorite = true
                }
            }
        }
    }
    
    // MARK: - Notification management
    
    @objc func bookDidChange(notification: NSNotification) {
        guard let book = notification.object as? AGTBook else {
            return
        }
        
        if book.favorite {
            tags.add(favoritesTagName, book: book)
            
            // avisar al delegado
            delegate?.library(self, bookFavoriteAdded: book)
        } else if tags.tagNames.contains(favoritesTagName) {
            // eliminar el libro de favoritos
            tags.remove(favoritesTagName, book: book)
            // avisar al delegado
            delegate?.library(self, bookFavoriteRemoved: book)
        }
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
    
    func booksForTag(tag: String) -> [AGTBook] {
        return tags.booksForTag(tag)
    }
}

protocol AGTLibraryDelegate {
    func library(library: AGTLibrary, bookFavoriteAdded: AGTBook)
    func library(library: AGTLibrary, bookFavoriteRemoved: AGTBook)
}
