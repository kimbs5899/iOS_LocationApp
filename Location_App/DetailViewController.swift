//
//  DetailViewController.swift
//  Location_App
//
//  Created by Designer on 2023/07/12.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }

}
