//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Alejandro on 02/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

let urlHackerBooks = "https://t.co/K9ziV0z3SJ"
let localBooksFilename = "books.json"
let favoritesBooks = "favorites.plist"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var library: AGTLibrary?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if isFirstTime() {
            
            do {
                try downloadJSONFrom(string: urlHackerBooks, asLocalName: localBooksFilename)
            } catch {
                fatalError("Error en downloadJSON")
            }
            
            setAppLaunched()
        }
        
        // load the JSON file containing the books
        let url = getLocalJSONURL().URLByAppendingPathComponent(localBooksFilename)
        
        guard let data = NSData(contentsOfURL: url) else {
            fatalError("Error while loading contents of JSON data")
        }
        
        do {
            let favorites = loadFavorites(getLocalJSONURL().URLByAppendingPathComponent(favoritesBooks))
            library = try AGTLibrary(jsonData: data, favorites: favorites)
            
            let libVC = AGTLibraryTableViewController(model: library!)
            let libNC = UINavigationController(rootViewController: libVC)
            let VC: UIViewController?
            
            library?.delegate = libVC
            
            let dev = UIDevice.currentDevice()
            if dev.userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                let bookVC = AGTBookViewController(model: library!.booksForTagAtIndex(0)[0])
                let bookNC = UINavigationController(rootViewController: bookVC)
                let splitVC = UISplitViewController()
                splitVC.viewControllers = [libNC, bookNC]
                
                libVC.delegate = bookVC
                VC = splitVC
            } else {
                VC = libNC
            }
            
            // meter el controlador en la ventana
            window?.rootViewController = VC
            
            window?.makeKeyAndVisible()
        } catch let error as HackerBooksError {
            print(error.description)
            return false
        } catch {
            print("Error on launching")
            return false
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        do {
            if let favs = library?.booksForTag(favoritesTagName) {
                try saveFavorites(getLocalJSONURL().URLByAppendingPathComponent(favoritesBooks), favorites: favs)
            }
        } catch let error as HackerBooksError {
            print(error.description)
        } catch {
            print("Error saving favorites")
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        do {
            if let favs = library?.booksForTag(favoritesTagName) {
                try saveFavorites(getLocalJSONURL().URLByAppendingPathComponent(favoritesBooks), favorites: favs)
            }
        } catch let error as HackerBooksError {
            print(error.description)
        } catch {
            print("Error saving favorites")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK: - Utils

/**
 *  Indica si es la primera vez que se lanza la aplicación.
 */
func isFirstTime() -> Bool {
    let userDef = NSUserDefaults.standardUserDefaults()
    let firstTime = !userDef.boolForKey("appLaunched")
    
    return firstTime
}

/**
 *  Establece que la aplicación ya ha sido arrancada.
 */
func setAppLaunched() {
    let userDef = NSUserDefaults.standardUserDefaults()
    userDef.setBool(true, forKey: "appLaunched")
}

/**
 *  Gets the local directory where JSON file is saved.
 */
func getLocalJSONURL() -> NSURL {
    // get the Documents directory where the cache will be saved
    let fm = NSFileManager.defaultManager()
    let urls = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
                                   inDomains: NSSearchPathDomainMask.UserDomainMask)
    let url = urls.last!
    
    return url
}

/**
 *  Downloads the JSON file with all books.
 *
 *  @param string URL's string where is the JSON file with the books.
 *  @param lName File local name where the JSON file will be saved.
 */
func downloadJSONFrom(string str: String, asLocalName lName: String) throws {
    let urlDst = getLocalJSONURL().URLByAppendingPathComponent(lName)
    
    // get the source url
    guard let urlSrc = NSURL(string: str) else {
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    // download the JSON file
    guard let data = NSData(contentsOfURL: urlSrc) else {
        throw HackerBooksError.downloadError
    }
    
    data.writeToURL(urlDst, atomically: true)
    
    /* XXX
     let task = NSURLSession.sharedSession().dataTaskWithURL(urlSrc) { (data, response, error) -> Void in
     if let urlContent = data, urlDst = NSURL(string: urlDir.absoluteString + lName) {
     urlContent.writeToURL(urlDst, atomically: true)
     }
     }
     
     task.resume()
     */
}
