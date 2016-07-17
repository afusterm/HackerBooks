//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Alejandro on 02/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

let favoriteDidChangeNotification = "Favorite tag did change"

class AGTBook: Hashable, Comparable {
    let title: String
    let authors: String
    let tags: [String]
    let image: UIImage
    let pdfURL: NSURL
    
    private var fav: Bool
    
    var favorite: Bool {
        get {
            return fav
        }
        
        set(newValue) {
            if fav != newValue {
                fav = newValue
                
                let nc = NSNotificationCenter.defaultCenter()
                let notif = NSNotification(name: favoriteDidChangeNotification, object: self)
                nc.postNotification(notif)
            }
        }
    }
    
    var hashValue: Int {
        return title.hashValue
    }
    
    var proxyForComparisson: String {
        return "\(title)\(authors)"
    }
    
    init(title: String, authors: String, tags: [String], image: UIImage, pdfURL: NSURL, favorite: Bool) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.pdfURL = pdfURL
        self.fav = favorite
    }
}

func ==(lhs: AGTBook, rhs: AGTBook) -> Bool {
    guard (lhs !== rhs) else {
        return true
    }
    
    return lhs.proxyForComparisson == rhs.proxyForComparisson
}

func <(lhs: AGTBook, rhs: AGTBook) -> Bool {
    return lhs.proxyForComparisson < rhs.proxyForComparisson
}
