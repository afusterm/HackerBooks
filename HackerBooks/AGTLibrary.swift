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
    fileprivate var books = [AGTBook]()
    fileprivate var tags = Tags()
    
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
    
    init(jsonData data: Data, favorites: [String]?) throws {
        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        var jsonBooks: JSONArray?
        if maybeArray is JSONArray {
            jsonBooks = maybeArray as? JSONArray
        } else if let dict = maybeArray as? JSONDictionary {
            jsonBooks = [dict]
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(bookDidChange), name: NSNotification.Name(rawValue: favoriteDidChangeNotification), object: nil)
        
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
    
    @objc func bookDidChange(_ notification: Notification) {
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
    
    func bookCountForTag(_ tag: String?) -> Int {
        return tags.bookCountForTag(tag)
    }
    
    func booksCountForTagAtIndex(_ tagIndex: Int) -> Int {
        return tags.booksCountForTagAtIndex(tagIndex)
    }
    
    func booksForTagAtIndex(_ tagIndex: Int) -> [AGTBook] {
        return tags.booksForTagAtIndex(tagIndex)
    }
    
    func booksForTag(_ tag: String) -> [AGTBook] {
        return tags.booksForTag(tag)
    }
}

protocol AGTLibraryDelegate {
    func library(_ library: AGTLibrary, bookFavoriteAdded: AGTBook)
    func library(_ library: AGTLibrary, bookFavoriteRemoved: AGTBook)
}
