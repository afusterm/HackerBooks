//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Alejandro on 06/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]


/**
 *  Decode a JSON dictionary into a AGTBook.
 *
 *  @param book JSON dictionary representing a book.
 */
func decode(book json: JSONDictionary) throws -> AGTBook {
    guard let title = json["title"] as? String else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    guard let authors = json["authors"] as? String else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    guard let imageStr = json["image_url"] as? String else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    guard let imageURL = URL(string: imageStr) else {
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    guard let pdfStr = json["pdf_url"] as? String else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    guard let pdfURL = URL(string: pdfStr) else {
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    guard let tagsStr = json["tags"] as? String else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    // remove all the trailing spaces in tags
    var tags = [String]()
    tagsStr.components(separatedBy: ",").forEach { (t: String) in
        tags.append(t.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    let book = AGTBook(title: title, authors: authors, tags: tags, imageURL: imageURL, pdfURL: pdfURL, favorite: false)
    
    return book
}
