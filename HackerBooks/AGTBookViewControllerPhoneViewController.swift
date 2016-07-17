//
//  AGTBookViewControllerPhoneViewController.swift
//  HackerBooks
//
//  Created by Alejandro on 16/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

class AGTBookViewControllerPhoneViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var switchFavorite: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    private var model: AGTBook
    
    init(model: AGTBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK: - Actions
    
    @IBAction func switchToFavorite(sender: AnyObject) {
        self.model.favorite = switchFavorite.on
    }
    
    @IBAction func openPDFViewer(sender: AnyObject) {
        let pdfVC = AGTSimplePDFViewController(model: self.model)
        self.navigationController?.pushViewController(pdfVC, animated: true)
    }
}
