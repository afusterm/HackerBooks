//
//  AGTLibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alejandro on 10/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

let libraryDidChangeNotification = "Selected book did change"

class AGTLibraryTableViewController: UITableViewController, AGTLibraryDelegate {
    fileprivate let model: AGTLibrary
    
    var delegate: AGTLibraryTableViewDelegate?
    
    init(model: AGTLibrary) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.title = "HackersBook"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(imageDidLoad), name: NSNotification.Name(rawValue: asyncImageDidLoadNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications
    
    func imageDidLoad(_ notification: Notification) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.tagNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.booksCountForTagAtIndex(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "HackerBookCellId"
        
        let bk = book(forIndexPath: indexPath)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        // sinchronize book and cell
        cell?.imageView?.image = bk.image
        cell?.textLabel?.text = bk.title
        cell?.detailTextLabel?.text = bk.authors

        // Configure the cell...

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.tagNames[section].capitalized
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bk = book(forIndexPath: indexPath)
        // avisar al delegado del cambio de libro
        delegate?.libraryTableViewController(self, didSelectBook: bk)
        
        // notificar del cambio de libro
        let nc = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: libraryDidChangeNotification), object: bk)
        nc.post(notification)
        
        let dev = UIDevice.current
        if dev.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            let bookVC = AGTBookViewControllerPhoneViewController(model: bk)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    func library(_ library: AGTLibrary, bookFavoriteAdded: AGTBook) {
        self.tableView.reloadData()
    }
    
    func library(_ library: AGTLibrary, bookFavoriteRemoved: AGTBook) {
        self.tableView.reloadData()
    }
    
    // MARK: - Utilities
    
    func book(forIndexPath indexPath: IndexPath) -> AGTBook {
        // get the book
        let books = model.booksForTagAtIndex((indexPath as NSIndexPath).section)
        return books[(indexPath as NSIndexPath).row]
    }
}

protocol AGTLibraryTableViewDelegate {
    func libraryTableViewController(_ vc: AGTLibraryTableViewController, didSelectBook: AGTBook)
}
