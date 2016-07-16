//
//  AGTBookViewController.swift
//  HackerBooks
//
//  Created by Alejandro on 03/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

class AGTBookViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var switchFavorite: UISwitch!
    
    var model: AGTBook
    
    // MARK: Initialization
    init(model: AGTBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Syncing
    func syncModelWithView() {
        coverImage.image = self.model.image
        titleLabel.text = self.model.title
        authorsLabel.text = self.model.authors
        
        // actualizar etiquetas
        var tags = ""
        for tag in self.model.tags {
            tags.appendContentsOf(tag)
            tags.appendContentsOf(" ")
        }
        
        tagsLabel.text = tags
        
        switchFavorite.on = self.model.favorite
    }
    
    // MARK: - View life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func switchToFavorite(sender: AnyObject) {
        self.model.favorite = switchFavorite.on
        NSLog("Favorite %@", self.model.favorite)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
