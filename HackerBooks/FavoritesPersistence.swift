//
//  FavoritesPersistence.swift
//  HackerBooks
//
//  Created by Alejandro on 17/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation

/**
 *  Saves the favorites as JSON file.
 */
func saveFavorites(url: NSURL, favorites: [AGTBook]) throws {
    let favs = NSMutableArray()
    
    for f in favorites {
        favs.addObject(f.title)
    }
    
    if favs.count > 0 {
        if !favs.writeToURL(url, atomically: true) {
            throw HackerBooksError.saveFileError
        }
    }
}

func loadFavorites(url: NSURL) -> [String] {
    var favorites = [String]()
    if let favs = NSArray(contentsOfURL: url) {
        favorites = favs as! [String]
    }
    
    return favorites
}
