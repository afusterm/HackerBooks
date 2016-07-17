//
//  AsyncImage.swift
//  HackerBooks
//
//  Created by Alejandro on 17/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import UIKit

let asyncImageDidLoadNotification = "Image was downloaded"

class AsyncImage {
    private let imagePlaceHolder = "placeholder.jpg"
    
    private var img: UIImage
    
    init(imageUrl url: NSURL) {
        // inicializar la imagen con la imagen placeholder
        img = UIImage(named: imagePlaceHolder)!
        
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: asyncImageDidLoadNotification, object: self)
        
        // descargar en segundo plano la imagen
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data, imgBg = UIImage(data: urlContent) {
                self.img = imgBg
                
                // notificar que se ha descargado la imagen
                nc.postNotification(notif)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Properties
    
    var image: UIImage {
        get {
            return img
        }
    }
}