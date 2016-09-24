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
func saveFavorites(_ url: URL, favorites: [AGTBook]) throws {
    let favs = NSMutableArray()
    
    for f in favorites {
        favs.add(f.title)
    }
    
    if favs.count > 0 {
        if !favs.write(to: url, atomically: true) {
            throw HackerBooksError.saveFileError
        }
    }
}

func loadFavorites(_ url: URL) -> [String] {
    var favorites = [String]()
    if let favs = NSArray(contentsOf: url) {
        favorites = favs as! [String]
    }
    
    return favorites
}
