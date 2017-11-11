//
//  RecipeWebView.swift
//  BBQApp
//
//  Created by Austin Dotto on 11/5/17.
//  Copyright © 2017 Jared Bruemmer. All rights reserved.
//

import UIKit
import WebKit

class RecipeWebView: UIViewController, WKUIDelegate{
    
    var webView: WKWebView!
    
    @IBOutlet weak var webViewOutlet: WKWebView!
    
    var website: String = ""

    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(website)
        let url:URL = URL(string: website)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

