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
    fileprivate let imagePlaceHolder = "placeholder.jpg"
    
    fileprivate var img: UIImage
    
    init(imageUrl url: URL) {
        // inicializar la imagen con la imagen placeholder
        img = UIImage(named: imagePlaceHolder)!
        
        let nc = NotificationCenter.default
        let notif = Notification(name: Notification.Name(rawValue: asyncImageDidLoadNotification), object: self)
        
        // descargar en segundo plano la imagen
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let urlContent = data, let imgBg = UIImage(data: urlContent) {
                self.img = imgBg
                
                // notificar que se ha descargado la imagen
                nc.post(notif)
            }
        }) 
        
        task.resume()
    }
    
    // MARK: - Properties
    
    var image: UIImage {
        get {
            return img
        }
    }
}
