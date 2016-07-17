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
        activityIndicator.startAnimating()
        
        // descargar el pdf si no está en local
        loadPDF()
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        syncModelWithView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // parar el activity view
        activityIndicator.stopAnimating()
        
        // ocultarlo
        activityIndicator.hidden = true
    }
    
    // MARK: - Helper functions
    
    private func loadPDF() {
        if let data = NSData(contentsOfURL: model.pdfURL),
            baseURL = model.pdfURL.URLByDeletingLastPathComponent {
            webView.loadData(data, MIMEType: "application/pdf", textEncodingName: "", baseURL: baseURL)
        }
    }
}
