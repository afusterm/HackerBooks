//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Alejandro on 02/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

class AGTBook {
    let title: String
    let authors: [String]
    let tags: [String]
    let image: UIImage
    let pdfURL: NSURL
    var favorite: Bool
    
    init(title: String, authors: [String], tags: [String], image: UIImage, pdfURL: NSURL, favorite: Bool) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.pdfURL = pdfURL
        self.favorite = favorite
    }
}