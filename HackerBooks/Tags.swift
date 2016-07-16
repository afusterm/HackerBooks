//
//  Tags.swift
//  HackerBooks
//
//  Created by Alejandro on 10/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation

typealias TagsDictionary = [String: Set<AGTBook>]

class Tags {
    private var tags: TagsDictionary
    private var names: [String]
    
    /**
     *  Total amount of tags
     */
    var tagNames: [String] {
        if names.count != tags.keys.count {
            populateTagNames()
        }
        
        return names
    }
    
    init() {
        tags = TagsDictionary()
        names = [String]()
    }
    
    func add(tag: String, book: AGTBook) {
        var books = tags[tag]
        if books == nil {
            books = Set<AGTBook>()
        }
        
        books!.insert(book)
        tags[tag] = books
    }
    
    /**
     *  Gets the number of books contained in a tag
     */
    func bookCountForTag(tag: String?) -> Int {
        if let t = tag, ts = tags[t] {
            return ts.count
        }
        
        return 0
    }
    
    func booksForTag(tag: String?) -> [AGTBook] {
        var booksArray = [AGTBook]()
        
        if let t = tag, books = tags[t] {
            for b in books {
                booksArray.append(b)
            }
        }
        
        return booksArray
    }
    
    func booksCountForTagAtIndex(tagIndex: Int) -> Int {
        if names.count != tags.keys.count {
            populateTagNames()
        }
        
        let tag = names[tagIndex]
        if let b = tags[tag] {
            return b.count
        }
        
        return 0
    }
    
    func booksForTagAtIndex(tagIndex: Int) -> [AGTBook] {
        if names.count != tags.keys.count {
            populateTagNames()
        }
        
        var books = [AGTBook]()
        
        if tagIndex >= names.count {
            return books
        }
        
        let tag = names[tagIndex]
        if let booksSet = tags[tag] {
            for b in booksSet {
                books.append(b)
            }
        }
        
        return books
    }
    
    func sort() {
    }
    
    // MARK: - Helper functions
    
    private func populateTagNames() {
        names.removeAll()
        names = Array(tags.keys)
        names = names.sort(<)
    }
}