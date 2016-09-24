//
//  AGTSimplePDFViewController.swift
//  HackerBooks
//
//  Created by Alejandro on 03/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit

class AGTSimplePDFViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: AGTBook
    
    init(model: AGTBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Syncing
    
    func syncModelWithView() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // descargar el pdf si no está en local
        loadPDF()
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.delegate = self
        
        // alta en la notificación de la tabla
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(libraryDidChange), name: NSNotification.Name(rawValue: libraryDidChangeNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        syncModelWithView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications
    
    func libraryDidChange(_ notification: Notification) {
        let book = notification.object as! AGTBook
        model = book
        syncModelWithView()
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // parar el activity view
        activityIndicator.stopAnimating()
        
        // ocultarlo
        activityIndicator.isHidden = true
    }
    
    // MARK: - Helper functions
    
    fileprivate func loadPDF() {
        // descargar en segundo plano la imagen
        let task = URLSession.shared.dataTask(with: self.model.pdfURL, completionHandler: { (data, response, error) -> Void in
            if let urlContent = data {
                let baseURL = self.model.pdfURL.deletingLastPathComponent()
                self.webView.load(urlContent, mimeType: "application/pdf", textEncodingName: "", baseURL: baseURL)
            }
        }) 
        
        task.resume()
    }
}
