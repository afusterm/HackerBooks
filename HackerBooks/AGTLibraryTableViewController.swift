//
//  AGTLibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alejandro on 10/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

class AGTLibraryTableViewController: UITableViewController, AGTLibraryDelegate {
    private let model: AGTLibrary
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.tagNames.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.booksCountForTagAtIndex(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "HackerBookCellId"
        
        let bk = book(forIndexPath: indexPath)
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // sinchronize book and cell
        cell?.imageView?.image = bk.image
        cell?.textLabel?.text = bk.title
        cell?.detailTextLabel?.text = bk.authors

        // Configure the cell...

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.tagNames[section].capitalizedString
    }
    
    // MARK: - Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bk = book(forIndexPath: indexPath)
        delegate?.libraryTableViewController(self, didSelectBook: bk)
        
        let dev = UIDevice.currentDevice()
        if dev.userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            let bookVC = AGTBookViewControllerPhone(model: bk)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    func library(library: AGTLibrary, bookFavoriteAdded: AGTBook) {
        self.tableView.reloadData()
    }
    
    func library(library: AGTLibrary, bookFavoriteRemoved: AGTBook) {
        self.tableView.reloadData()
    }
    
    // MARK: - Utilities
    
    func book(forIndexPath indexPath: NSIndexPath) -> AGTBook {
        // get the book
        let books = model.booksForTagAtIndex(indexPath.section)
        return books[indexPath.row]
    }
}

protocol AGTLibraryTableViewDelegate {
    func libraryTableViewController(vc: AGTLibraryTableViewController, didSelectBook: AGTBook)
}
