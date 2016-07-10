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
    private var books = [AGTBook]()
    
    init(jsonData data: NSData) throws {
        let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        
        var jsonBooks: JSONArray?
        if maybeArray is JSONArray {
            jsonBooks = maybeArray as? JSONArray
        } else if let dict = maybeArray as? JSONDictionary {
            jsonBooks = [dict]
        }
        
        // create the model through the JSON file
        for dict in jsonBooks! {
            let book = try decode(book: dict)
            books.append(book)
            
            // create the tags
            for tag in book.tags {
                tags.add(tag, book)
            }
        }
    }
}